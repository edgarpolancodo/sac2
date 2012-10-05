require 'sinatra'
require 'pg'

use Rack::Session::Pool
#Funcion de pagina indice
get '/' do
	erb :index
end
#Función que crea nueva conversación
post '/crear/nuevo' do
	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")
	if params[:_clave] != "true"	
		my.exec("insert into conversacion(ID) VALUES((select ID from conversacion ORDER BY ID DESC LIMIT 1)+1);")
	else
		my.exec("insert into conversacion(ID, Clave) VALUES((select ID from conversacion ORDER BY ID DESC LIMIT 1)+1, #{params[:clave]});")
	end
	res = my.exec("select * from conversacion ORDER BY ID DESC LIMIT 1;")
	res.each do |r|
		redirect "/crear/#{r['id']}"	
	end
end

get '/autenticar/:cid/:modo' do
	erb :clave, :locals => {:conversacion => params[:cid], :modo => params[:modo]}
end

post '/autenticar/:cid/:modo' do

	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")
	res = my.exec("select * from conversacion WHERE ID = '#{params[:cid]}' AND clave='#{params[:clave]}'")
	if res.ntuples == 1
		session[:modo] = params[:modo]
		session[:cid] = params[:cid]
		redirect "/#{params[:modo]}/#{params[:cid]}"
	else
		erb :clave, :locals => {:conversacion => params[:cid], :modo => params[:modo]}	
	end
	
end

post '/conversaciones' do

	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")
	cadena = "select ch.fechamodificacion as fechamodificacion, c.fechacreacion as fechacreacion, c.ID as id from conversacioneshistorial ch, conversacion c WHERE ch.ConversacionID = c.ID AND "
	params[:conversaciones].split(',').each do |c|
		cadena += "ch.ConversacionID='#{c}' or "	
	end
	res = my.exec(cadena[0..(cadena.length-4)])
	erb :conver, :locals => {:conversaciones => res}

end

#Función que crea la presentación de la conversación a trabajarse
get '/crear/:cid' do
	
	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")
	if my.exec("select * from conversacion where ID='#{params[:cid]}' and clave IS NULL").ntuples == 1 or (my.exec("select * from conversacion where ID='#{params[:cid]}' and clave <>''").ntuples > 0 and session[:modo] == "crear" and session[:cid] == params[:cid])
		res = my.exec("select * from Mensajes WHERE ConversacionID = '#{params[:cid]}'")
		res2 = my.exec("select r.ID as id, r.MensajeID as mensajeid, r.Texto as texto from Respuestas r, Mensajes m WHERE ConversacionID = '#{params[:cid]}' AND r.MensajeID = m.ID AND m.Tipo_Declaracion = 'abcd';")
		link = request.url.sub("crear", "responder")	
		erb :construir, :locals => {:mensajes => res, :respuestas => res2, :cid => params[:cid], :link => link}
	else
		redirect "/autenticar/#{params[:cid]}/crear"	
	end
end

#Función que toma los mensajes y respectivas respuesta de una conversación
post '/crear/:cid' do
	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")
	if my.exec("select * from conversacion where ID='#{params[:cid]}' and clave IS NULL").ntuples == 1 or (my.exec("select * from conversacion where ID='#{params[:cid]}' and clave <>''").ntuples > 0 and session[:modo] == "crear" and session[:cid] == params[:cid])
		link = request.url.sub("crear", "responder")
		mensajeID = "0"
		respuestaID = "0"
		#Esta parte ingresa el nuevo mensaje
		my.exec("insert into Mensajes(ConversacionID, Mensaje, Tipo_Declaracion) VALUES ('#{params[:cid]}', '#{params[:declaracion]}', '#{params[:tipo]}');")
	
		#Esta parte valida si el mensaje es basado en respuesta o continuación de mensaje anterior
		mID = ""	
		res = my.exec("select ID from Mensajes WHERE Mensaje = '#{params[:declaracion]}' AND Tipo_Declaracion = '#{params[:tipo]}' AND ConversacionID = '#{params[:cid]}'")
		#Esta parte ingresa las potenciales respuestas de un mensaje
		if params[:tipo] == "FREE"
			res.each do |row|
				mID = row['id'];
				my.exec("insert into Respuestas(MensajeID, Texto) VALUES "+
					"('#{row['id']}', '#{params[:respuestas]}');")
			end
	
		elsif
			res.each do |row|
				mID = row['id'];
				params[:respuestas].split("\n").each do |respuesta|
				my.exec("insert into Respuestas(MensajeID, Texto) VALUES "+
				"('#{row['id']}', '#{respuesta}');")
				end	
			end
		end
		if params[:origen] != nil 
		params[:origen].each do |o|	
				if o.include? 'm'
					mensajeID = o.split('m').last
					my.exec("insert into OrigenesDeMensajes(MensajeOrigenID, ConversacionID, MensajeID) VALUES('#{mensajeID}', '#{params[:cid]}', '#{mID}')")
				elsif o.include? 'r'
					respuestaID = o.split('r').last
					my.exec("insert into OrigenesDeRespuestas(RespuestaOrigenID, ConversacionID, MensajeID) VALUES('#{respuestaID}', '#{params[:cid]}', '#{mID}')")
				end
			end
		end
		#Esta parte genera la presentación
		res = my.exec("select * from Mensajes WHERE ConversacionID = '#{params[:cid]}'")
		res2 = my.exec("select r.ID as id, r.MensajeID as mensajeid, r.Texto as texto from Respuestas r, Mensajes m WHERE ConversacionID = '#{params[:cid]}' AND r.MensajeID = m.ID AND m.Tipo_Declaracion = 'abcd';")
		erb :construir2, :locals => {:mensajes => res, :respuestas => res2, :link => link}
	else
		redirect "/autenticar/#{params[:cid]}/crear"	
	end
end
#Función que genera la presentación para responder una conversación
get '/responder/:cid' do
	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")
	if my.exec("select * from conversacion where ID='#{params[:cid]}' and clave IS NULL").ntuples == 1 or (my.exec("select * from conversacion where ID='#{params[:cid]}' and clave <>''").ntuples > 0 and session[:modo] == "responder" and session[:cid] == params[:cid])
		men = my.exec("select * from Mensajes where ConversacionID = '#{params[:cid]}' ORDER BY ID ASC LIMIT 1;")
		mensajeid = ""
		mensaje = ""
		tipo = ""	
		men.each do |m|
			mensaje = m['mensaje']
			mensajeid = m['id']
			tipo = m['tipo_declaracion']	
		end
		res = my.exec("select * from Respuestas where MensajeID = '#{mensajeid}';")
		erb :responder, :locals => {:mensaje => mensaje, :mensajeid => mensajeid, :respuestas => res, :tipo => tipo, :cid => params[:cid]}
	else
		redirect "/autenticar/#{params[:cid]}/responder"		
	end
end

#Esta función toma las respuestas y luego muestra el siguiente mensaje
post '/responder/:cid' do
	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")
	respuestaid = params[:respuesta]
	texto = params[:texto]
	tipo = params[:tipo]
	conversacionhistorial = ""
	if params[:conversacionhistorial] == ""
		my.exec("insert into ConversacionesHistorial(ConversacionID, FechaModificacion, Finalizado_) VALUES ('#{params[:cid]}', current_timestamp, '0')")
		res = my.exec("select ID from ConversacionesHistorial ORDER BY ID DESC LIMIT 1;")
		res.each do |r|
			conversacionhistorial = r['id']	
		end 
	else
		conversacionhistorial = params[:conversacionhistorial]
	end 
	if tipo == "abcd" || tipo=="FREE"
		my.exec("insert into RespuestasHistorial(RespuestaID, Texto, MensajeID, ConversacionesHistorialID) VALUES ('#{respuestaid}', '#{texto}', '#{params[:mensajeid]}', '#{conversacionhistorial}')")	
	elsif tipo == "MS" 
		fila = 0
		respuestaid.each do |r|
			my.exec("insert into RespuestasHistorial(RespuestaID, Texto, MensajeID, ConversacionesHistorialID) VALUES ('#{r}', '#{texto[fila]}', '#{params[:mensajeid]}', '#{conversacionhistorial}')")
			fila+=1
		end
	end
	if tipo != "MS"
	men = my.exec("select m.ID as id, m.Mensaje as mensaje, m.Tipo_declaracion as tipo_declaracion from Mensajes m, OrigenesDeRespuestas odr where odr.RespuestaOrigenID = '#{respuestaid}' AND m.ID = odr.MensajeID;")
		if men.ntuples == 0
			men = my.exec("select m.ID as id, m.Mensaje as mensaje, m.Tipo_declaracion as tipo_declaracion from Mensajes m, OrigenesDeMensajes odm where odm.MensajeOrigenID = '#{params[:mensajeid]}' AND m.ID = odm.MensajeID;")
		end
	else
		men = my.exec("select m.ID as id, m.Mensaje as mensaje, m.Tipo_declaracion as tipo_declaracion from Mensajes m, OrigenesDeMensajes odm where odm.MensajeOrigenID = '#{params[:mensajeid]}' AND m.ID = odm.MensajeID;")
	end
	my.exec("update conversacioneshistorial set fechamodificacion = current_timestamp where ConversacionID='#{conversacionhistorial}'")
	mensajeid = ""
	mensaje = ""	
	tipo = ""
	men.each do |m|
		mensaje = m['mensaje']
		mensajeid = m['id']
		tipo = m['tipo_declaracion']	
	end
	if mensaje != ""
		res = my.exec("select * from Respuestas where MensajeID = '#{mensajeid}';")
		erb :responder2, :locals => {:mensaje => mensaje, :mensajeid => mensajeid, :respuestas => res, :tipo => tipo, :conversacionhistorial => conversacionhistorial}
	else
		my.exec("update conversacioneshistorial set finalizado_ = '1' where ID='#{conversacionhistorial}'")
		erb :responder2, :locals => {:mensaje => mensaje, :mensajeid => mensajeid, :respuestas => "", :tipo => tipo, :conversacionhistorial => ""}	
	end
end

#Esta función muestra en lectura la conversación ya respondida
get '/leer/:cid' do
	my = PGconn.open("ec2-107-21-106-52.compute-1.amazonaws.com", 5432, '', '',"d8fc8cbt6ec574", "fqcqofmgyilbwq", "VkrhL6BoGHvdk-e20WEZQYWqyh")	
	if my.exec("select * from conversacion where ID='#{params[:cid]}' and clave IS NULL").ntuples == 1 or (my.exec("select * from conversacion where ID='#{params[:cid]}' and clave <>''").ntuples > 0 and session[:modo] == "leer" and session[:cid] == params[:cid])
		con = my.exec("select m.Mensaje as mensaje, r.Texto as texto, rh.Texto as rh_texto, rh.conversacioneshistorialid as conversacionhistorialid from Mensajes m, Respuestas r, RespuestasHistorial rh where m.ConversacionID = '#{params[:cid]}' and r.MensajeID = m.ID and rh.RespuestaID = r.ID ORDER BY m.ID ASC;")
		con2 = my.exec("select * from conversacioneshistorial where ConversacionID='#{params[:cid]}' ORDER BY ID ASC;")
		erb :conversacion, :locals => {:conversacion => con2, :respuestas => con}	
	else
		redirect "/autenticar/#{params[:cid]}/leer"
	end
end


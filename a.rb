require 'sinatra'
require 'mysql'
require 'pg'
#Función que crea nueva conversación
get '/crear/nuevo' do
	my = PGconn.open("ec2-23-21-144-152.compute-1.amazonaws.com", 5432, '', '',"mjjsaotlzo", "mjjsaotlzo", "U9ZBrHHAQ0gBh6wHmkxd")
	my.exec("insert into conversacion VALUES((select ID from conversacion ORDER BY ID DESC LIMIT 1)+1);")
	res = my.exec("select * from conversacion ORDER BY ID DESC LIMIT 1;")
	res.each do |r|
		redirect "/crear/#{r[0]}"	
	end
end

#Función que crea la presentación de la conversación a trabajarse
get '/crear/:cid' do
	my = PGconn.open("ec2-23-21-144-152.compute-1.amazonaws.com", 5432, '', '',"mjjsaotlzo", "mjjsaotlzo", "U9ZBrHHAQ0gBh6wHmkxd")
	res = my.exec("select * from Mensajes WHERE ConversacionID = '#{params[:cid]}'")
	res2 = my.exec("select r.ID as id, r.MensajeID as mensajeid, r.Texto as texto from Respuestas r, Mensajes m WHERE ConversacionID = '#{params[:cid]}' AND r.MensajeID = m.ID AND m.Tipo_Declaracion = 'abcd';")
	link = request.url.sub("crear", "responder")	
	erb :index, :locals => {:mensajes => res, :respuestas => res2, :cid => params[:cid], :link => link}
	
end

#Función que toma los mensajes y respectivas respuesta de una conversación
post '/crear/:cid' do
	my = PGconn.open("ec2-23-21-144-152.compute-1.amazonaws.com", 5432, '', '',"mjjsaotlzo", "mjjsaotlzo", "U9ZBrHHAQ0gBh6wHmkxd")
	link = request.url.sub("crear", "responder")
	mensajeID = "0"
	respuestaID = "0"
	#Esta parte valida si el mensaje es basado en respuesta o continuación de mensaje anterior
	if params[:origen].include? 'm'
		mensajeID = params[:origen].split('m').last
	elsif params[:origen].include? 'r'
		respuestaID = params[:origen].split('r').last
	end
	#Esta parte ingresa el nuevo mensaje
	my.exec("insert into Mensajes(ConversacionID, Mensaje, Tipo_Declaracion, MensajeAnterior, BasadoRespuesta) VALUES ('#{params[:cid]}', '#{params[:declaracion]}', '#{params[:tipo]}', '#{mensajeID}', '#{respuestaID}');")

	my.exec("update Mensajes set MensajeAnterior = NULL, BasadoRespuesta = NULL Where MensajeAnterior=0 AND BasadoRespuesta=0;")
	res = my.exec("select ID from Mensajes WHERE Mensaje = '#{params[:declaracion]}' AND Tipo_Declaracion = '#{params[:tipo]}' AND ConversacionID = '#{params[:cid]}'")
	#Esta parte ingresa las potenciales respuestas de un mensaje
	if params[:tipo] == "FREE"
		res.each do |row|
			my.exec("insert into Respuestas(MensajeID, Texto) VALUES "+
				"('#{row['id']}', '#{params[:respuestas]}');")
		end
	
	elsif
		res.each do |row|
			params[:respuestas].split("\n").each do |respuesta|
			my.exec("insert into Respuestas(MensajeID, Texto) VALUES "+
			"('#{row['id']}', '#{respuesta}');")
			end	
		end
	end
	#Esta parte genera la presentación
	res = my.exec("select * from Mensajes WHERE ConversacionID = '#{params[:cid]}'")
	res2 = my.exec("select r.ID as id, r.MensajeID as mensajeid, r.Texto as texto from Respuestas r, Mensajes m WHERE ConversacionID = '#{params[:cid]}' AND r.MensajeID = m.ID AND m.Tipo_Declaracion = 'abcd';")
	erb :index2, :locals => {:mensajes => res, :respuestas => res2, :link => link}
	
end
#Función que genera la presentación para responder una conversación
get '/responder/:cid' do
	my = PGconn.open("ec2-23-21-144-152.compute-1.amazonaws.com", 5432, '', '',"mjjsaotlzo", "mjjsaotlzo", "U9ZBrHHAQ0gBh6wHmkxd")
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
	erb :responder, :locals => {:mensaje => mensaje, :mensajeid => mensajeid, :respuestas => res, :tipo => tipo}
end

#Esta función toma las respuestas y luego muestra el siguiente mensaje
post '/responder' do
	my = PGconn.open("ec2-23-21-144-152.compute-1.amazonaws.com", 5432, '', '',"mjjsaotlzo", "mjjsaotlzo", "U9ZBrHHAQ0gBh6wHmkxd")
	respuestaid = params[:respuesta]
	texto = params[:texto]
	tipo = params[:tipo]
	if tipo == "abcd" || tipo=="FREE"
		my.exec("insert into RespuestasHistorial(RespuestaID, Texto) VALUES ('#{respuestaid}', '#{texto}')")	
	elsif tipo == "MS" 
		fila = 0
		respuestaid.each do |r|
			my.exec("insert into RespuestasHistorial(RespuestaID, Texto) VALUES ('#{r}', '#{texto[fila]}')")
			fila+=1
		end
	end
	if tipo != "MS"
	men = my.exec("select * from Mensajes where BasadoRespuesta = '#{respuestaid}';")
		if men.ntuples == 0
			men = my.exec("select * from Mensajes where MensajeAnterior = '#{params[:mensajeid]}';")
		end
	else
		men = my.exec("select * from Mensajes where MensajeAnterior = '#{params[:mensajeid]}';")
	end
	mensajeid = ""
	mensaje = ""	
	tipo = ""
	men.each do |m|
		mensaje = m['mensaje']
		mensajeid = m['id']
		tipo = m['tipo_declaracion']	
	end
	res = my.exec("select * from Respuestas where MensajeID = '#{mensajeid}';")
	erb :responder2, :locals => {:mensaje => mensaje, :mensajeid => mensajeid, :respuestas => res, :tipo => tipo}

end

#Esta función muestra en lectura la conversación ya respondida
get '/leer/:cid' do
	my = PGconn.open("ec2-23-21-144-152.compute-1.amazonaws.com", 5432, '', '',"mjjsaotlzo", "mjjsaotlzo", "U9ZBrHHAQ0gBh6wHmkxd")
	con = my.exec("select m.Mensaje as mensaje, r.Texto as texto, rh.Texto as rh_texto from Mensajes m, Respuestas r, RespuestasHistorial rh where m.ConversacionID = '#{params[:cid]}' and r.MensajeID = m.ID and rh.RespuestaID = r.ID ORDER BY m.ID ASC;")
	erb :conversacion, :locals => {:conversacion => con}	
end

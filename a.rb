require 'sinatra'
require 'mysql'
#Función que crea nueva conversación
get '/crear/nuevo' do
	my = Mysql::new("localhost", "root", "asdasd", "sac")
	my.query("insert into conversacion VALUES();")
	res = my.query("select * from conversacion ORDER BY ID DESC LIMIT 1;")
	res.each do |r|
		redirect "/crear/#{r[0]}"	
	end
end

#Función que crea la presentación de la conversación a trabajarse
get '/crear/:cid' do
	my = Mysql::new("localhost", "root", "asdasd", "sac")
	res = my.query("select * from Mensajes WHERE ConversacionID = '#{params[:cid]}'")
	res2 = my.query("select * from Respuestas r, Mensajes m WHERE ConversacionID = '#{params[:cid]}' AND r.MensajeID = m.ID AND m.Tipo_Declaracion = 'abcd'")
	link = request.url.sub("crear", "responder")	
	erb :index, :locals => {:mensajes => res, :respuestas => res2, :cid => params[:cid], :link => link}
	
end

#Función que toma los mensajes y respectivas respuesta de una conversación
post '/crear/:cid' do
	my = Mysql::new("localhost", "root", "asdasd", "sac")
	link = request.url.sub("crear", "responder")
	mensajeID = "NULL"
	respuestaID = "NULL"
	#Esta parte valida si el mensaje es basado en respuesta o continuación de mensaje anterior
	if params[:origen].include? 'm'
		mensajeID = params[:origen].split('m').last
	elsif params[:origen].include? 'r'
		respuestaID = params[:origen].split('r').last
	end
	#Esta parte ingresa el nuevo mensaje
	my.query("insert into Mensajes(ConversacionID, Mensaje, Tipo_Declaracion, MensajeAnterior, BasadoRespuesta) VALUES "+
	"('#{params[:cid]}', '#{params[:declaracion]}', '#{params[:tipo]}', '#{mensajeID}', '#{respuestaID}');")

	my.query("update Mensajes set MensajeAnterior = NULL, BasadoRespuesta = NULL Where MensajeAnterior=0 AND BasadoRespuesta=0;")
	res = my.query("select ID from Mensajes WHERE Mensaje = '#{params[:declaracion]}' AND Tipo_Declaracion = '#{params[:tipo]}' AND ConversacionID = '#{params[:cid]}'")
	#Esta parte ingresa las potenciales respuestas de un mensaje
	if params[:tipo] == "FREE"
		res.each do |row|
			my.query("insert into Respuestas(MensajeID, Texto) VALUES "+
				"('#{row[0]}', '#{params[:respuestas]}')")
		end
	
	elsif
		res.each do |row|
			params[:respuestas].each do |respuesta|
			my.query("insert into Respuestas(MensajeID, Texto) VALUES "+
			"('#{row[0]}', '#{respuesta}')")
			end	
		end
	end
	#Esta parte genera la presentación
	res = my.query("select * from Mensajes WHERE ConversacionID = '#{params[:cid]}'")
	res2 = my.query("select * from Respuestas r, Mensajes m WHERE ConversacionID = '#{params[:cid]}' AND r.MensajeID = m.ID AND m.Tipo_Declaracion = 'abcd';")
	erb :index2, :locals => {:mensajes => res, :respuestas => res2, :link => link}
	
end
#Función que genera la presentación para responder una conversación
get '/responder/:cid' do
	my = Mysql::new("localhost", "root", "asdasd", "sac")
	men = my.query("select * from Mensajes where ConversacionID = '#{params[:cid]}' ORDER BY ID ASC LIMIT 1;")
	mensajeid = ""
	mensaje = ""
	tipo = ""	
	men.each do |m|
		mensaje = m[2]
		mensajeid = m[0]
		tipo = m[3]	
	end
	res = my.query("select * from Respuestas where MensajeID = '#{mensajeid}';")
	erb :responder, :locals => {:mensaje => mensaje, :mensajeid => mensajeid, :respuestas => res, :tipo => tipo}
end

#Esta función toma las respuestas y luego muestra el siguiente mensaje
post '/responder' do
	my = Mysql::new("localhost", "root", "asdasd", "sac")
	respuestaid = params[:respuesta]
	texto = params[:texto]
	tipo = params[:tipo]
	fila = 0
	respuestaid.each do |r|
		if tipo == "MS"
			my.query("insert into RespuestasHistorial(RespuestaID, Texto) VALUES ('#{r}', '#{texto[fila]}')")
			fila+=1
		else
			my.query("insert into RespuestasHistorial(RespuestaID, Texto) VALUES ('#{r}', '#{texto}')")
		end
	end
	if tipo != "MS"
	men = my.query("select * from Mensajes where BasadoRespuesta = '#{respuestaid}';")
		if men.num_rows() == 0
			men = my.query("select * from Mensajes where MensajeAnterior = '#{params[:mensajeid]}';")
		end
	else
		men = my.query("select * from Mensajes where MensajeAnterior = '#{params[:mensajeid]}';")
	end
	mensajeid = ""
	mensaje = ""	
	tipo = ""
	men.each do |m|
		mensaje = m[2]
		mensajeid = m[0]
		tipo = m[3]	
	end
	res = my.query("select * from Respuestas where MensajeID = '#{mensajeid}';")
	erb :responder2, :locals => {:mensaje => mensaje, :mensajeid => mensajeid, :respuestas => res, :tipo => tipo}

end

#Esta función muestra en lectura la conversación ya respondida
get '/leer/:cid' do
	my = Mysql::new("localhost", "root", "asdasd", "sac")
	con = my.query("select * from Mensajes m, Respuestas r, RespuestasHistorial rh where m.ConversacionID = '#{params[:cid]}' and r.MensajeID = m.ID and rh.RespuestaID = r.ID ORDER BY m.ID ASC;")
	erb :conversacion, :locals => {:conversacion => con}	
end

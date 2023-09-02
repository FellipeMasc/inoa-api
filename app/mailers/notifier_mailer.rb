class NotifierMailer < ApplicationMailer
	def notify_user(user, recomendacoes)
		array_recomendacao = []
		recomendacoes.map do |recomendacao|
			array_recomendacao << "Você deve #{recomendacao[:recomendacao]} o ativo #{recomendacao[:ativo]}"
		end
		@string_recomendacao = array_recomendacao.join(",")
		
		mail(to: "#{user.email}", subject: "Email de recomendação dos seus ativos cadastrados", 
		template_path: "notifier_mailer",
      	template_name: "notify_user" )
	end
end

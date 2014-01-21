module ApplicationHelper

	def flash_class(type)
		case type
		when :alert
			"alert-warning"
		when :notice
			"alert-info"
		else
			""
		end
	end
end

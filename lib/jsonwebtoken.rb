require 'jwt'

class JsonWebToken
		#Encode and sign jwt payload with exp
		
		def self.encode(payload)
			payload.reverse_merge!(meta)
			JWT.encode(payload, Rails.application.credentials.secret_key_base)
		end

		def self.decode(token)
			JWT.decode(token, Rails.application.credentials.secret_key_base)
		end

		def self.valid_payload(payload)
			#if expired(payload) && payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
			#	refresh(payload)
			#	return true
			#end

			if expired(payload) ||  payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
				return false
			else
				return true
			end
		end

		# def refresh(payload)
			#encode({ user_id: payload['user_id'], refresh_token: SecureRandom.hex(25) })
		#end

		def self.meta
			{
				exp: 45.minutes.from_now.to_i,
				iss: 'andio-app-for-helping-people',
				aud: 'client',
			}
		end

		def self.expired(payload)
			Time.at(payload['exp']) < Time.now
		end

	end

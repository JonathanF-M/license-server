class Api::V1::LicensesController < ApplicationController
  def create
    payload = {
      user: params[:user],
      asset_id: params[:asset_id],
      issued_at: Time.now.utc.iso8601
    }

    private_key = OpenSSL::PKey::RSA.new(File.read(ENV["PRIVATE_KEY_PATH"]))

    token = JWT.encode(payload, private_key, 'RS256')

    render json: {
      license: payload,
      signature: token
    }
  end
end

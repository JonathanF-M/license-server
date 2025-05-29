class Api::V1::ReadersController < ApplicationController
  def create
    reader = Reader.create!(
      public_key: params[:public_key],
      registered_at: Time.current
    )

    render json: {
      reader_id: reader.id,
      status: 'registered'
    }
  end
end

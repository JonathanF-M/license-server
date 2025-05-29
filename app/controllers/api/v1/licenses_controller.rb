class Api::V1::LicensesController < ApplicationController
  def create
    encryption_key = SecureRandom.hex(32)

    payload = {
      user: params[:user],
      asset_id: params[:asset_id],
      issued_at: Time.now.utc.iso8601,
      key: encryption_key
    }

    private_key = OpenSSL::PKey::RSA.new(File.read(ENV["PRIVATE_KEY_PATH"]))
    token = JWT.encode(payload, private_key, 'RS256')

    epub_path = find_epub_file(params[:asset_id])
    encrypted_epub = encrypt_epub(epub_path, encryption_key)

    render json: {
      license: token,
      encrypted_epub: Base64.encode64(encrypted_epub)
    }
  end

  def encrypt_epub(file_path, key_hex)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = [key_hex].pack('H*')
    iv = cipher.random_iv
    
    epub_content = File.read(file_path)
    encrypted = cipher.update(epub_content) + cipher.final
    
    iv + encrypted
  end

  def find_epub_file(asset_id)
    epub_dir = Rails.root.join('storage', 'epubs')
    file_path = epub_dir.join("#{asset_id}.epub")

    raise "Book not found" unless File.exist?(file_path)
    file_path
  end
end

class EnableUuidOsspExtension < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' if Rails.env.development? || Rails.env.test?
  end
end

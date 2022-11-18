module Firestore
  class Firestore
    require 'google/cloud/firestore'
    require 'singleton'

    class_attribute :firestore

    self.firestore ||= Google::Cloud::Firestore.new(
      project_id: ENV["GCP_PROJECT_ID"],
      credentials: Rails.root.join('config/firebase', ENV["GCP_AUTH_KEY_FILE"]).to_s
    )
    freeze
  end
end

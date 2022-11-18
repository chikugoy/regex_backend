require 'rails_helper'

# logger
Rails.logger = Logger.new(STDOUT)

RSpec.describe "Regexes", type: :request do
  before do
    (1..10).each { |i|
      Regex.create_by_id(
        :id => "test_regex_id_#{i}",
        :text => "test_regex_text_#{i}",
        'created_at' => Time.current,
        'updated_at' => Time.current
      )
    }

    @regexes = Regex.find_by
    @regexes.freeze
  end

  context "index" do
    it 'all data' do
      get '/api/v1/regexes'
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      expect(json['data'].length).to eq(@regexes.length)
    end

    it 'where text = *' do
      get '/api/v1/regexes?text=test_regex_text_1'
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      expect(json['data'].length).to eq(1)
      expect(json['data'][0]['text']).to eq('test_regex_text_1')
    end

    it 'where id = *' do
      get '/api/v1/regexes?id=test_regex_id_2'
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      expect(json['data'].length).to eq(1)
      expect(json['data'][0]['id']).to eq('test_regex_id_2')
    end
  end

  context "show" do
    it 'id = test_regex_id_1' do
      get '/api/v1/regexes/test_regex_id_1'
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      expect(json['data']['id']).to eq('test_regex_id_1')
    end

    it 'id = test_regex_id_9' do
      get '/api/v1/regexes/test_regex_id_9'
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      expect(json['data']['id']).to eq('test_regex_id_9')
    end
  end

  context "create" do
    it 'valid ok, id = test_regex_id_create_1' do
      valid_params = {
        id: 'test_regex_id_create_1',
        text: 'test_regex_text_create_1',
      }

      post '/api/v1/regexes', params: valid_params
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      expect(json['data']['id']).to eq('test_regex_id_create_1')

      regex = Regex.new(:id => "test_regex_id_create_1")
      regex.delete
    end

    it 'valid ok, id is nothing' do
      valid_params = {
        text: 'test_regex_text_create_1',
      }

      post '/api/v1/regexes', params: valid_params
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      regex = Regex.new(:id => json['data']['id'])
      regex.delete
    end

    it 'valid ng, text empty' do
      valid_params = {
        id: 'test_regex_id_create_1',
        text: '',
      }

      post '/api/v1/regexes', params: valid_params
      json = JSON.parse(response.body)

      expect(response.status).to eq(400)

      expect(json['data'][0]).to eq('比較テキストを入力してください')

      regex = Regex.new(:id => "test_regex_id_create_1")
      regex.delete
    end


    it 'valid ng, text is nothing' do
      valid_params = {
        id: 'test_regex_id_create_1',
      }

      post '/api/v1/regexes', params: valid_params
      json = JSON.parse(response.body)

      expect(response.status).to eq(400)

      expect(json['data'][0]).to eq('比較テキストを入力してください')

      regex = Regex.new(:id => "test_regex_id_create_1")
      regex.delete
    end
  end

  context "update" do
    it 'valid ok' do
      before_regex = Regex.find_row('test_regex_id_1')
      valid_params = {
        text: 'test_regex_text_update_1',
      }

      put '/api/v1/regexes/test_regex_id_1', params: valid_params
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)

      expect(json['data']['id']).to eq('test_regex_id_1')
      expect(json['data']['text']).to eq('test_regex_text_update_1')

      after_regex = Regex.find_row('test_regex_id_1')
      expect(json['data']['text']).to eq(after_regex.text)
      expect(before_regex.text).not_to eq(after_regex.text)
      expect(before_regex.updated_at).not_to eq(after_regex.updated_at)
    end

    it 'valid ng, text is empty' do
      before_regex = Regex.find_row('test_regex_id_1')
      valid_params = {
        text: '',
      }

      put '/api/v1/regexes/test_regex_id_1', params: valid_params
      json = JSON.parse(response.body)

      expect(response.status).to eq(400)

      expect(json['data'][0]).to eq('比較テキストを入力してください')

      after_regex = Regex.find_row('test_regex_id_1')
      expect(before_regex.text).to eq(after_regex.text)
      expect(before_regex.updated_at).to eq(after_regex.updated_at)
    end
  end

  context "destroy" do
    it 'id = test_regex_id_1' do
      before_regex = Regex.find_row('test_regex_id_1')
      before_regexes = Regex.find_by

      delete '/api/v1/regexes/test_regex_id_1'

      expect(response.status).to eq(200)

      after_regex = Regex.find_row('test_regex_id_1')
      after_regexes = Regex.find_by

      expect(before_regex).to_not be_nil
      expect(after_regex).to be_nil
      expect(before_regexes.length).to eq(after_regexes.length + 1)
    end

    it 'id = test_regex_id_8' do
      before_regex = Regex.find_row('test_regex_id_8')
      before_regexes = Regex.find_by

      delete '/api/v1/regexes/test_regex_id_8'

      expect(response.status).to eq(200)

      after_regex = Regex.find_row('test_regex_id_8')
      after_regexes = Regex.find_by

      expect(before_regex).to_not be_nil
      expect(after_regex).to be_nil
      expect(before_regexes.length).to eq(after_regexes.length + 1)
    end
  end

  after do
    (1..10).each { |i|
      regex = Regex.new(:id => "test_regex_id_#{i}")
      regex.delete
    }
  end
end
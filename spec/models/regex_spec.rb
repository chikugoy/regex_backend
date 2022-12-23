require 'rails_helper'

# logger
Rails.logger = Logger.new($stdout)

RSpec.describe 'Regex', type: :model do
  describe 'validate' do
    regex_base = Regex.new(
      text: 'test',
      created_at: Time.current,
      updated_at: Time.current
    )

    context 'text' do
      it 'presence: true' do
        regex = regex_base.deep_dup
        regex.text = ''
        expect(regex.valid?).to eq false
        expect(regex.errors.full_messages[0]).to eq '比較テキストを入力してください'
      end
    end

    context 'created_at' do
      it 'presence: true' do
        regex = regex_base.deep_dup

        regex.created_at = nil
        expect(regex.valid?).to eq false
        expect(regex.errors.full_messages[0]).to eq '作成日を入力してください'
      end
    end

    context 'updated_at' do
      it 'presence: true' do
        regex = regex_base.deep_dup

        regex.updated_at = nil
        expect(regex.valid?).to eq false
        expect(regex.errors.full_messages[0]).to eq '更新日を入力してください'
      end
    end
  end
end

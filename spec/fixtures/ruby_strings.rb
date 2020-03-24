module RubyStrings
  def mail_subject(user)
    I18n.t(
      'registration_mailer',
      user: user.name
    )
  end

  def mail_subject_notification(user)
    I18n.t(
      'registration_mailer.change_notification',
      user: user.name,
    )
  end

  send_change_notification(action: 'updated', user: user, template: 'registration_mailer/change_notification/group')

  def user_params
    ::ActionController::Parameters.new(
      { 'data' => { 'attributes' => {
        'email' => user.email,
        'name' => user.name,
        'locale' => 'fr',
      } } }
    )
  end
end

RSpec.describe 'Api V1 import create' do
  let(:user) { create :user }

  describe 'uploads file' do
    it 'returns success on file upload' do
      file = from_fixture('import.csv')
      send_post_request(:import, data_csv: file)

      expect(response).to have_http_status :no_content
    end
  end
end

# regular comment

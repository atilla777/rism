# frozen_string_literal: true

RSpec.shared_examples 'an anonymous' do
  it 'can`t visit index' do
    get :index

    expect(response).to redirect_to(:sign_in)
  end

  it 'can`t visit show' do
    get :show, params: { id: record.id }

    expect(response).to redirect_to(:sign_in)
  end

  it 'can`t visit new' do
    get :new

    expect(response).to redirect_to(:sign_in)
  end

  it 'can`t create' do
    expect { new_record }.not_to(change { model_class.count })
    expect(response).to redirect_to(:sign_in)
  end

  it 'can`t visit edit' do
    get :edit, params: { id: record.id }

    expect(response).to redirect_to(:sign_in)
  end

  it 'can`t update' do
    expect { update_record }
      .not_to(change { model_class.find(record.id).attributes })
    expect(response).to redirect_to(:sign_in)
  end

  it 'can`t destroy' do
    record

    expect { delete_record }.not_to change(model_class, :count)
    expect(response).to redirect_to(:sign_in)
  end
end

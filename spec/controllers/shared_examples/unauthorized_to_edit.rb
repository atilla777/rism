# frozen_string_literal: true

RSpec.shared_examples 'unauthorized to edit' do
  it 'can`t visit new' do
    get :new

    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t create' do
    expect { new_record }.not_to(change { model_class.count })
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t visit edit' do
    get :edit, params: { id: record.id }

    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t update' do
    expect { update_record }
      .not_to(change { model_class.find(record.id).attributes })
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t destroy' do
    record

    expect { delete_record }.not_to change(model_class, :count)
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end
end

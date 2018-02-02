# frozen_string_literal: true

RSpec.shared_examples 'unauthorized to access not allowed' do
  it 'cant`t view not allowed in index' do
    get :index

    expect(assigns(:records)).not_to include(not_allowed_record)
    expect(response).to render_template(:index)
  end

  it 'cant`t view show' do
    get :show, params: { id: not_allowed_record.id }

    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t visit edit' do
    get :edit, params: { id: not_allowed_record.id }

    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t update' do
    expect { update_not_allowed_record }
      .not_to(change { model_class.find(not_allowed_record.id).attributes })
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t destroy' do
    not_allowed_record

    expect { delete_not_allowed_record }.not_to change(model_class, :count)
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end
end

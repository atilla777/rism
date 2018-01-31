# frozen_string_literal: true

RSpec.shared_examples 'a reader' do
  it 'can view records' do
    get :index

    expect(assigns(:records)).to match_array(model.all)
    expect(response).to render_template(:index)
  end

  it 'can visit show' do
    get :show, params: { id: record.id }

    expect(response).to render_template(:show)
  end

  it 'can`t visit new' do
    get :new

    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t create' do
    expect { new_record }.to_not change { model.count }
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t visit edit' do
    get :edit, params: { id: record.id }

    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t update' do
    expect { update_record }.to_not change { model.find(record.id).attributes }
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can`t destroy' do
    sacrifice_record

    expect { delete_record }.not_to change(model, :count)
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end
end

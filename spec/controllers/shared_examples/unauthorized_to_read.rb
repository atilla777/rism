# frozen_string_literal: true

RSpec.shared_examples 'unauthorized to read' do
  it 'cant`t view index' do
    get :index

    expect(assigns(:records)).not_to be
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'cant`t view show' do
    get :show, params: { id: record.id }

    expect(assigns(:record)).not_to be
    expect(flash[:danger]).to be
    expect(response).to have_http_status(:redirect)
  end
end


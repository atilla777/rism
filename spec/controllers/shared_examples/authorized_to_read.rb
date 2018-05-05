# frozen_string_literal: true

RSpec.shared_examples 'authorized to read' do
  it 'can view records' do
    get :index

    expect(assigns(:records)).to match_array(all_records)
    expect(response).to render_template(:index)
  end

  it 'can visit show' do
    get :show, params: { id: record.id }

    expect(assigns(:record)).to eq(record)
    #expect(response).to render_template(:show)
    expect(response).to have_http_status(:success)
  end
end

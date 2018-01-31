# frozen_string_literal: true

RSpec.shared_examples 'an admin' do
  it 'can view records' do
    get :index

    expect(assigns(:records)).to match_array(model.all)
    expect(response).to render_template(:index)
  end

  it 'can visit show' do
    get :show, params: { id: record.id }

    expect(response).to render_template(:show)
  end

  it 'can visit new' do
    get :new

    expect(response).to render_template(:new)
  end

  it 'can create' do
    expect { new_record }.to change { model.count }.by(1)
    expect(flash[:success]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can visit edit' do
    get :edit, params: { id: record.id }

    expect(response).to render_template :edit
  end

  it 'can update' do
    expect { update_record }.to change { model.find(record.id).attributes }
    expect(flash[:success]).to be
    expect(response).to redirect_to(controller.polymorphic_path(record))
  end

  it 'can destroy' do
    sacrifice_record

    expect { delete_record }.to change(model, :count).by(-1)
    expect(flash[:success]).to be
    expect(response).to redirect_to(controller.polymorphic_path(model))
  end
end

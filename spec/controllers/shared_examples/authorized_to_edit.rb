# frozen_string_literal: true

RSpec.shared_examples 'authorized to edit' do
  it 'can visit new' do
    get :new, params: new_params

    expect(response).to render_template(:new)
  end

  it 'can create' do
    controller.session[:edit_return_to] = controller.polymorphic_path(model_class)

    expect { new_record }.to(change { model_class.count }.by(1))
    expect(flash[:success]).to be
    expect(response).to have_http_status(:redirect)
  end

  it 'can visit edit' do
    get :edit, params: { id: record.id }

    expect(response).to render_template :edit
  end

  it 'can update' do
    controller.session[:edit_return_to] = controller.polymorphic_path(record)

    expect { update_record }
      .to(change { model_class.find(record.id).attributes })
    expect(flash[:success]).to be
    expect(response).to redirect_to(controller.session[:edit_return_to])
  end

  it 'can destroy' do
    record

    expect { delete_record }.to(change(model_class, :count).by(-1))
    expect(flash[:success]).to be
    expect(response).to redirect_to(controller.polymorphic_path(model_class))
  end
end

class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource :need
  load_and_authorize_resource :expense, :through => :need

  # GET /need/:need_id/expenses
  # GET /need/:need_id/expenses.json
  def index
  	@need = Need.find(params[:need_id])
    @expenses = @need.expenses.all
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  	@need = Need.find(params[:need_id])
  end

  # GET /expenses/new
  def new
  	@need = Need.find(params[:need_id])
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
    @need = Need.find(params[:need_id])
  end

  # POST /expenses
  # POST /expenses.json
  def create
  	@need = Need.find(params[:need_id])
    @expense = @need.expenses.new(expense_params)
    respond_to do |format|
      if @expense.save
        format.html { redirect_to [@need, @expense], notice: 'Expense was successfully created.' }
        format.json { render action: 'show', status: :created, location: @expense }
      else
        format.html { render action: 'new' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
  	@need = Need.find(params[:need_id])
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to [@need, @expense], notice: 'Expense was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to root_path, :flash => { :notice => "Expense deleted." } }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:amount_cents, :title, :description, :documentation)
    end
end

class ImportsController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy]

  # GET /imports
  # GET /imports.json
  def index
    @imports = Import.all
  end

  # GET /imports/1
  # GET /imports/1.json
  def show
  end

  # GET /imports/new
  def new
    @import = Import.new
  end

  # GET /imports/1/edit
  def edit
  end

  # POST /imports
  # POST /imports.json
  def create
    uploaded_io = params[:import][:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @import = Import.create :file_name => uploaded_io.original_filename

    lines = File.readlines(Rails.root.join('public', 'uploads', uploaded_io.original_filename))
    lines.shift #remove header line
    lines.each do |l|
      order = build_order l
      order.import = @import
      order.save
      puts "order total: #{order.total}"
    end

    puts "import total: #{@import.orders.map{|o| o.total}.inject(:+)}"

    redirect_to @import, notice: 'Import was successfully created.' 
  end

  def build_order line
    order = Order.new

    fields = line.split("\t")
    # for debugging
    # puts 
    # puts "new order"
    # puts "---------"
    # puts "purchaser name #{fields[0]}"
    # puts "item name #{fields[1]}"
    # puts "item price #{fields[2]}"
    # puts "item qty #{fields[3]}"
    # puts "merchant address #{fields[4]}"
    # puts "merchant name #{fields[5]}"

    p = Purchaser.find_or_create_by(name: fields[0]) {|p| p.name = fields[0]}
    order.purchaser = p

    i = Item.find_by_description(fields[1]) || Item.create(:description => fields[1], :price => fields[2])
    order.item = i

    m = Merchant.find_by_name(fields[5]) || Merchant.create(:name => fields[5], :address => fields[4])
    i.merchant = m
    i.save

    order.quantity = fields[3]
    order
  end

  # PATCH/PUT /imports/1
  # PATCH/PUT /imports/1.json
  def update
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params[:import]
    end
end

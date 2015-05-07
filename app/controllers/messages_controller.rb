class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    @message.to = message_params[:to]
    @message.from = message_params[:from]
    @message.text = message_params[:text]

    @agent = Agent.where(:bw_phone_number => message_params[:to]).first

    @message.agent_id = @agent.id

    # this SMS is from a customer, find the agent and forward it
    if @message.from != @agent.agent_phone_number

      @customer = Customer.where(:phone_number => @message.from, :agent_id => @agent.id).first_or_create
      @message.customer_id = @customer.id
      @message.msg_type = 'customer'

      Bandwidth::Message.create(
          :from => @agent.bw_phone_number,
          :to => @agent.agent_phone_number,
          :text => @customer.id.to_s + ": " + @message.text
      )

    # this SMS is from a agent, send it to the customer  
    elsif @message.from == @agent.agent_phone_number 

        # look for a id: at the beginning of message
        if /\d:/.match(@message.text)

            _tmp_customer = /\d+:/.match(@message.text).to_s            
            _tmp_customer_id = /\d+/.match(_tmp_customer).to_s


            if !Customer.find_by_id(_tmp_customer_id.to_i).nil?

              @customer = Customer.find(_tmp_customer_id.to_i)

              # parse message and remove id: field
              Bandwidth::Message.create(
                :from => @agent.bw_phone_number,
                :to => @customer.phone_number,
                :text => @message.text.gsub(/\d+:/, '')
              )

              # clean up and record response in database
              @message.msg_type = 'agent_reply'
              @message.text = @message.text.gsub(/\d+:/, '')
              @message.from = @agent.bw_phone_number
              @message.to = @customer.phone_number
              @message.customer_id = @customer.id
              
            else # no customer found, send agent an error back

              Bandwidth::Message.create(
                :from => @agent.bw_phone_number,
                :to => @agent.agent_phone_number,
                :text => "Sorry, that customer id was not found, can you check again and reply with id:, for example '1: your message'"
              )

              # clean up and record response in database
              @message.msg_type = 'reply_error_no_customer_found'
              @message.text = @message.text.gsub(/\d+:/, '')
              @message.from = @agent.bw_phone_number
              @message.to = @agent.agent_phone_number

            end

        else # forgot to tell us who to send to, give them instructions back

          Bandwidth::Message.create(
            :from => @agent.bw_phone_number,
            :to => @agent.agent_phone_number,
            :text => 'When replying to a customer, first include the customer id, for example put 1: at the start of your reply message and we will send to that customer.'
          )

          @message.msg_type = 'reply_error_no_id_included'

        end

    end


    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:to, :from, :agent_id, :customer_id, :text, :msg_type)
    end
end

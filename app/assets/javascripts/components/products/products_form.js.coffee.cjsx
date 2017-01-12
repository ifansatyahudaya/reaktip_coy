{ createClass, PropTypes } = React
{ Row, Col, FormGroup, FormControl, ControlLabel, ButtonToolbar
  Button } = ReactBootstrap

@ProductsForm = createClass
  displayName: 'ProductsForm'

  propTypes:
    csrfParamName: PropTypes.string.isRequired
    csrfToken: PropTypes.string.isRequired

  getInitialState: ->
    {
      product: ProductsFormStore.getProduct()
      isLoading: ProductsFormStore.getIsLoading()
      errors: ProductsFormStore.getErrors()
      measurementOptions: ProductsFormStore.getMeasurementOptions()
    }

  componentDidMount: ->
    ProductsFormStore.addChangeListener(@_onChange)

    productFormComponent = ReactDOM.findDOMNode(@refs.productForm)
    $(productFormComponent)
      .on "ajax:beforeSend", (xhr) =>
        @_dispatchLoading(true)
      .on "ajax:success", (e, product, status, xhr) =>
        isProductNew = _.isNil(@state.product.id)
        @_onSuccessSubmit(product, isProductNew)
      .on "ajax:error", (e, xhr, status, error) =>
        @_onFailedSubmit(xhr.responseJSON)

  componentWillUnmount: ->
    ProductsFormStore.removeChangeListener()

  render: ->
    # Props Variables Declaration
    { csrfParamName, csrfToken } = @props

    # State Variables Declaration
    { product, isLoading, measurementOptions, errors } = @state

    # Declaration of Product attributes as Variables
    { id, name, price, quantity, description, measurement } = product

    # Input Names
    prefixName              = 'product'
    inputProductName        = "#{prefixName}[name]"
    inputProductPrice       = "#{prefixName}[price]"
    inputProductQuantity    = "#{prefixName}[quantity]"
    inputProductMeasurement = "#{prefixName}[measurement]"
    inputProductDescription = "#{prefixName}[description]"

    # Helper Variables
    isProductNew   = _.isNil(id)
    formActionPath = if isProductNew then Routes.products_path() else Routes.product_path(id)
    formMethod     = if isProductNew then 'POST' else 'PATCH'

    <form ref="productForm" action={formActionPath} method='post' data-remote={true} data-type='json'>
      <FormErrors errors={errors} />
      <input type='hidden' name={csrfParamName} value={csrfToken} />
      <input type='hidden' name='_method' value={formMethod} />

      <FormGroup controlId="productsFormInputName">
        <ControlLabel>Name</ControlLabel>
        <FormControl name={inputProductName} value={name}
          onChange={@onChangeInput.bind(@, 'name')} disabled={isLoading} />
      </FormGroup>

      <FormGroup controlId="productsFormInputPrice">
        <ControlLabel>Price</ControlLabel>
        <FormControl name={inputProductPrice} type='number' value={price}
          onChange={@onChangeInput.bind(@, 'price')} disabled={isLoading} />
      </FormGroup>

      <FormGroup controlId="productsFormInputQuantity">
        <ControlLabel>Quantity</ControlLabel>
        <FormControl name={inputProductQuantity} type='number' value={quantity}
          onChange={@onChangeInput.bind(@, 'quantity')} disabled={isLoading} />
      </FormGroup>

      <FormGroup controlId="productsFormInputMeasurement">
        <ControlLabel>Measurement</ControlLabel>
        <FormControl name={inputProductMeasurement} componentClass="select"
          value={measurement} onChange={@onChangeInput.bind(@, 'measurement')}
          disabled={isLoading}>
          <option value={null}></option>
          {
            measurementOptions.map (option, index) ->
              <option key={index} value={option}>{option}</option>
          }
        </FormControl>
      </FormGroup>

      <FormGroup controlId="productsFormInputDescription">
        <ControlLabel>Description</ControlLabel>
        <FormControl name={inputProductDescription} componentClass="textarea" value={description}
          onChange={@onChangeInput.bind(@, 'description')} disabled={isLoading} />
      </FormGroup>

      <ButtonToolbar>
        <Button bsStyle='success' type='submit' disabled={isLoading}>
          { if isLoading then 'Please Wait...' else 'Submit' }
        </Button>
      </ButtonToolbar>
    </form>

  # BEGIN -- Form Input Events
  onChangeInput: (attrName, event) ->
    @_dispatchChangeProduct("#{attrName}": event.target.value)
  # END -- Form Input Events

  # BEGIN -- Action Dispatch
  _dispatchChangeProduct: (attributes) ->
    dispatcher.dispatch
      actionType: 'products-form/product:change'
      attributes: attributes

  _dispatchSetForm: (product, isLoading, errors) ->
    dispatcher.dispatch
      actionType: 'products-form:set'
      product: product
      isLoading: isLoading
      errors: errors

  _dispatchLoading: (isLoading) ->
    dispatcher.dispatch
      actionType: 'products-form/isLoading:set'
      isLoading: isLoading
  # END -- Action Dispatch

  # BEGIN -- Callbacks
  _onSuccessSubmit: (product, isProductNew) ->
    if isProductNew
      actionType = 'products-table/product:add'
    else
      actionType = 'products-table/product:change'

    dispatcher.dispatch
      actionType: actionType
      product: product

    @_dispatchSetForm(null, false, [])

  _onFailedSubmit: (errors) ->
    @_dispatchSetForm(@state.product, false, errors)

  _onChange: ->
    @setState
      product: ProductsFormStore.getProduct()
      isLoading: ProductsFormStore.getIsLoading()
      errors: ProductsFormStore.getErrors()
      measurementOptions: ProductsFormStore.getMeasurementOptions()

  # END -- Callbacks

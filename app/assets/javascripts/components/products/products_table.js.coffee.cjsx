{ createClass, PropTypes } = React
{ Table, Glyphicon } = ReactBootstrap

@ProductsTable = createClass
  displayName: 'ProductsTable'

  getInitialState: ->
    {
      products: ProductsTableStore.getProducts()
    }

  componentDidMount: ->
    ProductsTableStore.addChangeListener(@_bruceWayne)

  componentWillUnmount: ->
    ProductsTableStore.removeChangeListener()

  render: ->
    # State Variables Declaration
    { products } = @state

    # Components
    productRow = (product, index) =>
      ordinalNumber = index + 1
      <tr key={index}>
        <td>{ordinalNumber}</td>
        <td>{product.name}</td>
        <td>{product.price}</td>
        <td>{product.quantity}</td>
        <td>{product.measurement}</td>
        <td>
          <a href="javascript:void(0);">
            <Glyphicon glyph="pencil" onClick={@onClickEditItem.bind(@, product)} />
          </a>
        </td>
        <td>
          <a href="javascript:void(0);">
            <Glyphicon onClick={@onClickRemoveItem.bind(@, product)} glyph="remove" />
          </a>
        </td>
      </tr>

    <Table striped bordered condensed hover responsive>
      <thead>
        <tr>
          <th>#</th>
          <th>Name</th>
          <th>Price</th>
          <th>Quantity</th>
          <th>Measurement</th>
          <th colSpan="2" />
        </tr>
      </thead>
      <tbody>
        {products.map(productRow)}
      </tbody>
    </Table>

  # BEGIN -- table row Events
  onClickRemoveItem: (product) ->
    swal {
      title: "Are you sure?"
      type: "warning"
      showCancelButton: true,
      confirmButtonColor: "#DD6B55"
      confirmButtonText: "Yes, delete it!"
      closeOnConfirm: true
    }, (isConfirmed) =>
      @_removeProduct(product) if isConfirmed

  onClickEditItem: (product) ->
    dispatcher.dispatch
      actionType: 'products-form:set'
      product: product
  # END -- table row events

  # BEGIN -- Callbacks
  _bruceWayne: ->
    @setState
      products: ProductsTableStore.getProducts()
  # END -- Callbacks

  _removeProduct: (product) ->
    $.ajax
      url: Routes.product_path(product.id)
      method: 'DELETE'
      success: ->
        dispatcher.dispatch
          actionType: 'products-table/product:remove'
          product: product

        dispatcher.dispatch
          actionType: 'products-form/product:should_clear'
          productId: product.id

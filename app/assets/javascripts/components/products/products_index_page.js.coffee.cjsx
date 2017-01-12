{ createClass, PropTypes } = React
{ Row, Col, PageHeader } = ReactBootstrap

@ProductsIndexPage = createClass
  displayName: 'ProductsIndexPage'

  propTypes:
    csrfParamName: PropTypes.string.isRequired
    csrfToken: PropTypes.string.isRequired

  render: ->
    # Props Variables Declaration
    { csrfParamName, csrfToken } = @props

    <div className='container'>
      <PageHeader>
        Products <small>List of All Products</small>
      </PageHeader>
      <Row>
        <Col xs={12} sm={6} md={4}>
          <ProductsForm csrfParamName={csrfParamName} csrfToken={csrfToken} />
        </Col>
        <Col xs={12} sm={6} md={8}>
          <ProductsTable />
        </Col>
      </Row>
    </div>

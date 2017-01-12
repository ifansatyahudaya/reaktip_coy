{ EventEmitter } = fbemitter # ieu naon

CHANGE_EVENT = 'products-form:change'

baseProduct = -> { name: '', price: '', quantity: '', measurement: '', description: '' }

window.ProductsFormStore = _.assign(new EventEmitter(), {
  product: baseProduct()
  isLoading: false
  errors: {}
  measurementOptions: []

  # BEGIN -- getter
  getProduct: -> @product
  getIsLoading: -> @isLoading
  getErrors: -> @errors
  getMeasurementOptions: -> @measurementOptions
  # END -- GETTER

  # BEGIN -- emitter & listener
  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)
  removeChangeListener: -> @removeAllListeners(CHANGE_EVENT)
  # END -- emitter & listener
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'products-form:initialize'
      { product, errors, measurementOptions } = payload

      ProductsFormStore.product            = product || baseProduct()
      ProductsFormStore.errors             = errors || []
      ProductsFormStore.measurementOptions = measurementOptions || []

      ProductsFormStore.emitChange()

    when 'products-form:set'
      { product, errors, isLoading } = payload

      ProductsFormStore.product   = product || baseProduct()
      ProductsFormStore.errors    = errors || []
      ProductsFormStore.isLoading = isLoading || false

      ProductsFormStore.emitChange()

    when 'products-form/product:change'
      { attributes } = payload

      product = ProductsFormStore.product
      ProductsFormStore.product = _.assign(product, attributes)

      ProductsFormStore.emitChange()

    when 'products-form/isLoading:set'
      { isLoading } = payload

      ProductsFormStore.isLoading = isLoading

      ProductsFormStore.emitChange()

    when 'products-form/product:should_clear'
      { productId } = payload

      product = ProductsFormStore.product

      if product.id == productId
        ProductsFormStore.product = baseProduct()

        ProductsFormStore.emitChange()

{ EventEmitter } = fbemitter

CHANGE_EVENT = 'products-form:change'

baseProduct = -> { name: '', price: '', quantity: '', measurement: '', description: '' }

product            = baseProduct()
isLoading          = false
errors             = {}
measurementOptions = []

window.ProductsFormStore = _.assign(new EventEmitter(), {
  # BEGIN -- getter
  getProduct: -> product
  getIsLoading: -> isLoading
  getErrors: -> errors
  getMeasurementOptions: -> measurementOptions
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

      product            = product || baseProduct()
      errors             = errors || []
      measurementOptions = measurementOptions || []

      ProductsFormStore.emitChange()

    when 'products-form:set'
      { product, errors, isLoading } = payload

      product   = product || baseProduct()
      errors    = errors || []
      isLoading = isLoading || false

      ProductsFormStore.emitChange()

    when 'products-form/product:change'
      { attributes } = payload

      product = _.assign(product, attributes)

      ProductsFormStore.emitChange()

    when 'products-form/isLoading:set'
      { isLoading } = payload

      isLoading = isLoading

      ProductsFormStore.emitChange()

    when 'products-form/product:should_clear'
      { productId } = payload

      if product.id == productId
        product = baseProduct()

        ProductsFormStore.emitChange()

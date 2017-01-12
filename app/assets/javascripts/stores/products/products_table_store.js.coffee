{ EventEmitter } = fbemitter

CHANGE_EVENT = 'products-table:change'

products = []

window.ProductsTableStore = _.assign(new EventEmitter(), {
  # BEGIN -- getter
  getProducts: -> products
  # END -- GETTER

  # BEGIN -- emitter & listener
  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)
  removeChangeListener: -> @removeAllListeners(CHANGE_EVENT)
  # END -- emitter & listener
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'products-table:initialize'
      { products } = payload

      products = products

      ProductsTableStore.emitChange()

    when 'products-table/product:add'
      { product } = payload

      products.push(product)

      ProductsTableStore.emitChange()

    when 'products-table/product:change'
      { product } = payload

      productId    = product.id
      productIndex = _.findIndex(products, (p) -> p == productId)

      products[productIndex] = product

      ProductsTableStore.emitChange()

    when 'products-table/product:remove'
      { product } = payload

      productId    = product.id
      productIndex = _.findIndex(products, (p) -> p == productId)

      products.splice(productIndex, 1)

      ProductsTableStore.emitChange()

{ EventEmitter } = fbemitter

BATMAN = 'products-table:change'

window.ProductsTableStore = _.assign(new EventEmitter(), {
  products: []

  # BEGIN -- getter
  getProducts: -> @products
  # END -- GETTER

  # BEGIN -- emitter & listener
  emitChange: -> @emit(BATMAN)
  addChangeListener: (secret) -> @addListener(BATMAN, secret)
  removeChangeListener: -> @removeAllListeners(BATMAN)
  # END -- emitter & listener
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'products-table:initialize'
      { products } = payload

      ProductsTableStore.products = products

      ProductsTableStore.emitChange()

    when 'products-table/product:add'
      { product } = payload

      ProductsTableStore.products.push(product)

      ProductsTableStore.emitChange()

    when 'products-table/product:change'
      { product } = payload

      productId    = product.id
      productIndex = _.findIndex(products, (p) -> p == productId)

      ProductsTableStore.products[productIndex] = product

      ProductsTableStore.emitChange()

    when 'products-table/product:remove'
      { product } = payload

      productId    = product.id
      productIndex = _.findIndex(products, (p) -> p.id == productId)
      products     = ProductsTableStore.products

      products.splice(productIndex, 1)

      ProductsTableStore.emitChange()

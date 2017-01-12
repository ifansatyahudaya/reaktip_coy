{ createClass, PropTypes } = React

@FormErrors = createClass
 propTypes:
   errors: PropTypes.array

 getDefaultProps: ->
   {
     errors: []
   }

 render: ->
   {errors} = @props

   liError = (error, index) -> <li key={index}>{error}</li>

   if errors.length > 0
     <div className='alert alert-danger' role='alert' style={style}>
       <ul>
         {errors.map(liError)}
       </ul>
     </div>
   else
     null
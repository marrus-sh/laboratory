#  `示.Module`  #

##  Usage  ##

>   ```jsx
>       <Module
>           attributes=React.PropTypes.object
>           close=React.PropTypes.bool
>           closeTo=React.PropTypes.object
>       >
>           {/*  contents  */}
>       </Module>
>   ```
>   Creates a module overlay, rendering its contents inside. The accepted properties are:
>   -   **`attributes` [Optional `object`] :**
>       Attributes to set on the `<main>` object.
>   -   **`close` [OPTIONAL `boolean`] :**
>       Whether or not the module should be closed.
>   -   **`closeTo` [OPTIONAL `string`] :**
>       The URL to redirect the user to upon closing.

##  The Component  ##

The `Module` component is just a fairly simple React component, which loads a module as the `<main>` element on the page with a curtain behind.

    示.Module = React.createClass

        propTypes:
            attributes: React.PropTypes.object
            close: React.PropTypes.bool
            closeTo: React.PropTypes.string

        getInitialState: ->
            shouldClose: false

###  Pulling from the context:

We grab the router from the React context in order to handle page navigation.

        contextTypes:
            router: React.PropTypes.object.isRequired

`close()` is a simple function that runs if our module has the `close` property set.
If there is somewhere to `closeTo`, then it redirects the user there; if not, it attemps to navigate back and if that fails instead redirects home.
We do this on a `.5s` timeout to give our closing animation time to run.

        close: ->
            @setState {shouldClose: true}
            window.setTimeout (=> if @props.closeTo or @context.router.length <= 1 then @context.router.push(@props.closeTo or "/") else @context.router.goBack()), 500

The `render()` function displays our module: just a `<div>` curtain behind our `<main>` element, with children stuck inside.

        render: ->
            @close() if @props.close and not @state.shouldClose
            目 "div", (if @state.shouldClose then {id: "laboratory-module", "data-laboratory-dismiss": ""} else {id: "laboratory-module"}),
                目 "div", {id: "laboratory-curtain", onClick: @close}
                目 "main", (if @props.attributes? then @props.attributes else null),
                @props.children

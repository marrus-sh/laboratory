#  `/components/middleware/errors`  #

This module produces the necessary middleware to display error messages when something goes wrong.
It imports `showAlert` which produces the actual alert.

    import { showAlert } from '../actions/alerts'

We're just gonna assume for now that something is a fail if it contains `FAIL` and that it's a success if it contains `SUCCESS`.
Sounds reasonable.

    defaultSuccessSuffix = 'SUCCESS'
    defaultFailSuffix = 'FAIL'

Here it is in `RegExp` form:

    isSuccess = new RegExp(defaultSuccessSuffix, 'g')
    isFail = new RegExp(defaultFailSuffix, 'g')

Here's our `default` function.
The string of anonymous functions handles the middleware bit, dwbi too much.

    export default () -> ({ dispatch }) -> (next) -> (action) ->

If our our `action` doesn't have a `type` then… can't really do much.
So we make sure that's the case and see if our `action` failed.
(We don't actually check for successes haha.)

        if action.type and action.type.match(isFail)

If we have an actual response then hey let's show that thing.


            if action.error.response
                { data, status, statusText } = action.error.response
                message = if data.error then data.error else statusText
                title   = String(status)
                dispatch showAlert(title, message)

Otherwise it's just something generic.

>   **Issue:**
>   This should be localized.

            else
                console.error action.error
                dispatch showAlert('Oops!', 'An unexpected error occurred.')

Onward!

        return next(action)

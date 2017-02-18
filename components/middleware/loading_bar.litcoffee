#  `components/middleware/loading_bar`  #

This module is used to render the cool-looking loading_bar to let you know how your requests are going.
Obviously, we're gonna need to import some stuff from `react-redux-loading-bar`.

    import { showLoading, hideLoading } from 'react-redux-loading-bar'

Generally we can be in one of three states when it comes to a request: it can be `PENDING`, it can be `FULFILLED`, or it can be `REJECTED`.

    defaultTypeSuffixes = ['PENDING', 'FULFILLED', 'REJECTED']

Our `default` function accepts an object for configuration; the only property we care about though is `config.promiseTypeSuffixes`.
This lets us override the defaults we just declared above.

    export default (config = {}) ->
        promiseTypeSuffixes = config.promiseTypeSuffixes || defaultTypeSuffixes

If we have an `action` and we're not `skipLoading` it, then we should try to figure out what state it is.
If it's pending then we want to *show* the loading bar; if it's not then let's *hide* it.

        return ({ dispatch }) -> (next) -> (action) ->
            if action.type and not action.skipLoading
                [PENDING, FULFILLED, REJECTED] = promiseTypeSuffixes
                isPending       = new RegExp(`${PENDING}$`, 'g')
                isFulfilled     = new RegExp(`${FULFILLED}$`, 'g')
                isRejected      = new RegExp(`${REJECTED}$`, 'g')
                if action.type.match(isPending) then dispatch(showLoading())
                else if action.type.match(isFulfilled) or action.type.match(isRejected) then
                dispatch(hideLoading())
            return next(action)

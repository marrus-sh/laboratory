import axios from 'axios'
import LinkHeader from 'http-link-header'

export getLinks = (response) ->
    value = response.headers.link
    return {refs: []} unless value
    return LinkHeader.parse(value)

export default (getState) -> axios.create({
    headers:
        'Authorization': `Bearer ${getState().getIn(['meta', 'access_token'], '')}`

    transformResponse: [(data) -> {
        try return JSON.parse(data)
        catch Exception
      return data;
    }]

})

jQuery ->
  remove_link = jQuery "a.remove"

  remove_link.on "click", (event)->
    event.preventDefault()
    event.stopPropagation()

    a = jQuery(this)

    remove = confirm("确定要删除吗?")

    if remove
      deferred = jQuery.ajax
        url: a.attr("href")
        method: "delete"

      deferred.then (res)->
        window.location.href = res

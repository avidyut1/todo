# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
###
  Models
 ###
$(document).ready(() ->
  class Todoitem extends Backbone.Model
    urlRoot: '/todo'
    initialize: ()->
      console.log('new model init')
  ###
    Collections
   ###

  class Todolist extends Backbone.Collection
    url: '/todo',
    model: Todoitem
    parse: (response)->
      response.todo

  ###
    Views
   ###
  class Todoitemview extends Backbone.View
    initialize: (model) ->
      @model = model
    className: 'todo-item'
    tagName: 'div'
    template: Handlebars.compile($("#example").html())
    events:
      'dblclick p': 'edit'
      'keypress input': 'update'
      'click input.check': 'toggleCompleted'
    edit: () ->
      @.$('#'+@.model.id).hide();
      @.$('#edit'+@.model.id).show();
    update: (e) ->
      if e.which == 13 && @.$('#edit'+@.model.id).val().trim()
        @.$('#'+@.model.id).show();
        @.$('#edit'+@.model.id).hide();
        newText = @.$('#edit'+@.model.id).val();
        @model.set('text', newText);
        @model.save()
        @.$el.html(@template(@.model.toJSON()))
    toggleCompleted: () ->
      @model.set('completed', !@model.get('completed'))
      @model.save()
      @.$el.html(@template(@.model.toJSON()))
    render: () =>
      @.$el.html(@template(@.model.toJSON()))
      $('.body').append(@.$el)
      @

  class Todolistview extends Backbone.View
    render: () =>
      todolist = new Todolist()
      todolist.fetch(success: ()->
        for model in todolist.models
          new Todoitemview(model).render()
      )

  class Appview extends Backbone.View
    el: $('.body')
    events:
      'keypress .new-todo': 'createOnEnter'
    createOnEnter: (e) ->
      if (e.which == 13 && $('.new-todo').val().trim())
        val = $('.new-todo').val().trim()
        nm = new Todoitem({'text': val})
        nm.save(null, {
          success: (model, response, options) =>
            $('.new-todo').val('')
            nm.id = response.id
            new Todoitemview(nm).render()
        })
    render: () ->
      todolistview = new Todolistview();
      todolistview.render()

  appview = new Appview()
  appview.render()
)
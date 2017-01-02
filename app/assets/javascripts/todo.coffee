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

  class SingleTodoView extends Backbone.View
    initialize: (id) ->
      @model = new Todoitem()
      @model.set('id', id)
      @model.fetch(success: (response)=>
        @model = response
        @.render()
      )
    render: () ->
      new Todoitemview(@model).render('.body2')

  class Appview extends Backbone.View
    el: $('.body')
    template: Handlebars.compile($('#entertodo').html())
    events:
      'keypress .new-todo': 'createOnEnter'
    createOnEnter: (e) ->
      e.stopPropagation()
      if (e.which == 13 && $('.new-todo').val().trim())
        val = $('.new-todo').val().trim()
        nm = new Todoitem({'text': val})
        nm.save(null, {
          success: (model, response, options) =>
            $('.new-todo').val('')
            nm.id = response.id
            new Todoitemview(nm).render()
        })
    clear: ()->
      @.$el.html('');
    render: () ->
      @.$el.append(@.template())
      todolistview = new Todolistview();
      todolistview.render()

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
      'click p': 'view'
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
    view: () ->
      app_router.navigate('todo/'+@model.get('id'), {trigger: true})
    render: (selector) =>
      @.$el.html(@template(@.model.toJSON()))
      $(selector || '.body').append(@.$el)
      @

  class Todolistview extends Backbone.View
    render: () =>
      todolist = new Todolist()
      todolist.fetch(success: ()->
        for model in todolist.models
          new Todoitemview(model).render()
      )


  ###Router ###
  appview = new Appview()
  class AppRouter extends Backbone.Router
    routes:
      "todo/:id": "getTodo",
      "*actions": "defaultRoute"
    getTodo: (id)->
      $('.body').addClass('dnone')
      $('.body2').removeClass('dnone').empty();
      stv = new SingleTodoView(id)
    defaultRoute: (actions) ->
      if (actions == 'home')
        $('.body').removeClass('dnone')
        $('.body2').addClass('dnone');
        #fetch mode
        appview.clear()
        appview.render()
      else if (actions == 'about')
        console.log('in about')
  app_router = new AppRouter();
  Backbone.history.start();
  app_router.navigate('home', {trigger: true})

  class Navbar extends Backbone.View
    events:
      'click .home': 'home'
      'click .about': 'about'
    template: Handlebars.compile($("#nav").html())
    render: () ->
      @.$el.html(@template())
      $('.nav').append(@.$el)
      @
    home: ()->
      app_router.navigate('home', {trigger: true})
    about: ()->
      app_router.navigate('about', {trigger: true})

  navbar = new Navbar()
  navbar.render()
)

var App = Ember.Application.create();

// Store
//
App.store = DS.Store.create({
  adapter: DS.RESTAdapter
});

// Node Sample
//
App.Sample = DS.Model.extend({ 
  cpuAvg5: DS.attr('string'),
  createdAt: DS.attr('date'),
  didLoad: function() { 
    console.log('Sample loaded; id=' + this.get('id'));
  }
});

// Node
//
App.Node = DS.Model.extend({
  ipAddress: DS.attr('string'),
  samples: DS.hasMany(App.Sample),
  didLoad: function() { 
    console.log('Node loaded; id=' + this.get('id'));

    // TODO: Hack to force enumeration and eager loading.
    // TODO: Find a way to either obtain this from a mixin or inheritance.
    this.get('samples').map(function(item, index, self) { 
      return item
    });
  }
});

// Cluster
//
App.Cluster = DS.Model.extend({
  name: DS.attr('string'),
  nodes: DS.hasMany(App.Node),
  didLoad: function() { 
    console.log('Cluster loaded; id=' + this.get('id'));

    // TODO: Hack to force enumeration and eager loading.
    // TODO: Find a way to either obtain this from a mixin or inheritance.
    this.get('nodes').map(function(item, index, self) { 
      return item
    });
  }
});

App.ready = (function() { 
  App.store.find(App.Cluster, '1');
});

o = {};

$('table.target tr').each(function(index, row){

  first_column = $('td', row).first();
  name = first_column.text().toLowerCase();

  last_column = $('td', row).last().text();

  parts = last_column.split(/\n|,/);
  parts = parts.map( function( el ){ return el.trim(); });

  type = parts.shift();
  description = parts.pop();
  validations = parts.length > 0 ? parts.join(', ') : null;
  o[ name ] = {
    "type": type,
    "validations": validations,
    "description": description
  }
});

JSON.stringify(o);
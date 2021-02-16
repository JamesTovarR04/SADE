import React, { Component } from 'react';
import ReactDOM from 'react-dom';

function AppSade(){

    return (
      <div>
        <h1><i className="fas fa-book"></i>Hola mundo!</h1>
      </div>
    );

}

if (document.getElementById('appSade')) {
    ReactDOM.render(<AppSade />, document.getElementById('appSade'));
}
package com.ihc.apirest.controllers;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.ihc.apirest.models.Cliente;
import com.ihc.apirest.repository.ClienteRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;




@RestController
@RequestMapping("/api/cliente")
public class ClienteRestController 
{
    @Autowired
    ClienteRepository clienteRepository;


    SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
    


    /**
     * Método que permite crear un nuevo cliente en BD
     * @param cliente, Cliente a crear
     * @return Cliente creado
     */
    @PostMapping(value="/covid")
    public ResponseEntity<Long> crearCliente(@RequestBody Cliente cliente)
    {
        Long cantidadClientes = null;

        try 
        {
            cliente.getLstVisitas().get(0).setCliente(cliente);

            //Este metodo creará un usuario en BD
            clienteRepository.save(cliente);

            cantidadClientes = clienteRepository.aforoClientes(Long.parseLong(format.format(new Date())));
            
            return new ResponseEntity<Long>(cantidadClientes, HttpStatus.CREATED);
		} 
        catch (Exception e) 
        {
            return new ResponseEntity<Long>(cantidadClientes, HttpStatus.INTERNAL_SERVER_ERROR);
		}
     }



     /**
     * Método que permite actualizar un cliente en BD
     * @param cliente, Cliente actualizar
     * @return Cliente actualizado
     */
    @PutMapping("/covid")
    public ResponseEntity<Long> actualizarCliente(@RequestBody Cliente cliente)
    {
        Long cantidadClientes = null;

        try 
        {
            cliente.getLstVisitas().get(0).setCliente(cliente);

            //Este metodo creará un usuario en BD
            clienteRepository.save(cliente);
        
            cantidadClientes = clienteRepository.aforoClientes(Long.parseLong(format.format(new Date())));
            
            return new ResponseEntity<Long>(cantidadClientes, HttpStatus.CREATED);
		} 
        catch (Exception e) 
        {
            return new ResponseEntity<Long>(cantidadClientes, HttpStatus.INTERNAL_SERVER_ERROR);
		}
     }
	
    
    /**
     * Método que permite obtener un cliente según la cédula
     * @param cedula, Cédula con la cual se buscara el cliente en BD
     * @return Cliente encontrado
     */
    @GetMapping(value = "/covid/{cedula}")
    public ResponseEntity<Cliente> findByCedula(@PathVariable String cedula) 
    {
        try
        {
            Cliente cliente = clienteRepository.findByCedula(cedula);

            // if(null != cliente)
            // {
            //     //Se suprime el objeto cliente de la vista ya que al devolver la entidad cliente por apirest no soporta las referencias ciclicas
            //     for (Visita visita : cliente.getLstVisitas())
            //     {
            //         visita.setCliente(null);
            //     }
            // }
            
            return new ResponseEntity<Cliente>(cliente, HttpStatus.OK);
        }
        catch (Exception e) 
        {
			return new ResponseEntity<Cliente>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    


    /**
     * Método que permite crear un nuevo cliente en BD, para la app [mi-bario-app]
     * @param cliente, Cliente a crear
     * @return Cliente creado
     */
    @PostMapping(value="/barrio")
    public ResponseEntity<Cliente> crearClienteBarrio(@RequestBody Cliente cliente)
    {
        try 
        {
            Cliente clienteExistente = clienteRepository.findByEmail(cliente.getEmail());

            //Se valida que el email del cliente no este registrado en la plataforma
            if(null != clienteExistente)
            {
                return new ResponseEntity<Cliente>(clienteExistente, HttpStatus.CREATED);
            }

            //Este metodo creará un usuario en BD para la app de [mi-bario-app]
            Cliente clienteBD = clienteRepository.save(cliente);

            return new ResponseEntity<Cliente>(clienteBD, HttpStatus.CREATED);
		} 
        catch (Exception e) 
        {
            return new ResponseEntity<Cliente>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
     }



     /**
     * Método que permite actualizar un cliente en BD
     * @param cliente, Cliente actualizar
     * @return Cliente actualizado
     */
    @PutMapping("/barrio")
    public ResponseEntity<Boolean> actualizarClienteBarrio(@RequestBody Cliente cliente)
    {
        try 
        {
            //Este metodo creará un cliente en BD
            clienteRepository.save(cliente);
            
            return new ResponseEntity<Boolean>(true, HttpStatus.CREATED);
		} 
        catch (Exception e) 
        {
            return new ResponseEntity<Boolean>(false, HttpStatus.INTERNAL_SERVER_ERROR);
		}
     }
	
    
    /**
     * Método que permite obtener un cliente según el telefono o email
     * @param cliente, Cliente que contiente telefono o email con el cual se buscara al cliente en BD
     * @return Cliente encontrado
     */
    @PostMapping(value = "/barrio/validar")
    public ResponseEntity<Cliente> validarCliente(@RequestBody Cliente cliente) 
    {
        try
        {
            Cliente clienteBD = clienteRepository.validarCliente(cliente.getTelefono(), cliente.getEmail(), cliente.getPassword());
            
            return new ResponseEntity<Cliente>(clienteBD, HttpStatus.OK);
        }
        catch (Exception e) 
        {
			return new ResponseEntity<Cliente>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
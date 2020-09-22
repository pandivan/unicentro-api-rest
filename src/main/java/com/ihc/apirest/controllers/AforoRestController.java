package com.ihc.apirest.controllers;

import java.util.Date;

import com.ihc.apirest.models.Aforo;
import com.ihc.apirest.repository.AforoRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;



@RestController
@RequestMapping("/api/aforo")
public class AforoRestController 
{
    @Autowired
    AforoRepository aforoRepository;


    /**
     * Método que permite registra el ingreso de un cliente en BD
     * @return Total clientes ingreso menos total clientes salida
     */
    @PostMapping(value="/ingreso")
    public ResponseEntity<Long> registrarIngreso()
    {
        Long aforoTotalClientes = null;

        try 
        {
            Aforo aforo = new Aforo();
            aforo.setFechaIngreso(new Date());
            
            //Registando salida de cliente
            aforoRepository.saveAndFlush(aforo);

            aforoTotalClientes = aforoTotalClientes();
            
            return new ResponseEntity<Long>(aforoTotalClientes, HttpStatus.CREATED);
		} 
        catch (Exception e) 
        {
            return new ResponseEntity<Long>(aforoTotalClientes, HttpStatus.INTERNAL_SERVER_ERROR);
		}
     }



    /**
     * Método que permite registra la salida de un cliente en BD
     * @return Total clientes ingreso menos total clientes salida
     */
    @PostMapping(value="/salida")
    public ResponseEntity<Long> registrarSalida()
    {
        Long aforoTotalClientes = null;

        try 
        {
            Aforo aforo = new Aforo();
            aforo.setFechaSalida(new Date());

            aforoTotalClientes = aforoTotalClientes();
            aforoTotalClientes -= 1;

            if(aforoTotalClientes >= 0)
            {
                //Registando salida de cliente
                aforoRepository.saveAndFlush(aforo);
            }
            
            return new ResponseEntity<Long>(aforoTotalClientes, HttpStatus.CREATED);
		} 
        catch (Exception e) 
        {
            return new ResponseEntity<Long>(aforoTotalClientes, HttpStatus.INTERNAL_SERVER_ERROR);
		}
     }



     /**
      * Método que permite calcular el total de aforo de clientes
      * @return
      */
     private Long aforoTotalClientes()
     {
        Long aforoTotalClientes = null;

        try 
        {
            long aforoClientesIngreso = aforoRepository.aforoClientesIngreso();

            long aforoClientesSalida = aforoRepository.aforoClientesSalida();

            aforoTotalClientes = aforoClientesIngreso - aforoClientesSalida;

            if(null == aforoTotalClientes || 0 > aforoTotalClientes.longValue())
            {
                aforoTotalClientes = (long) 0;
            }
            
            return aforoTotalClientes;
		} 
        catch (Exception e) 
        {
            return (long)0;
		}
     }
}
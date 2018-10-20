class Formacion {
	var locomotoras = []
	var vagones = []
	
	method acoplarVagon(unVagon){
	   vagones.add(unVagon)
	}
	
	method acoplarLocomotora(unaLocomotora){
		locomotoras.add(unaLocomotora)
	}
	
	method vagonesLivianos(){
    return vagones.count { vagon => vagon. pesoMaximo() < 2500 }
	}
	
	method velocidadMaxima(){
		var velocidades = locomotoras.map{locomotora => locomotora.velocidadMaxima() }
		return velocidades.min()	
	}
	
	method esEficiente(){
		return locomotoras.all{locomotora =>locomotora.arrastreUtil() >=  locomotora.peso() * 5}		
	}
	
	method arrastreUtilTotal(){
	  return locomotoras.sum{locomotora => locomotora.arrastreUtil()}
	}
	
	method pesoTotalVagones(){
		return  vagones.sum{vagon => vagon.pesoMaximo()}
	}
	method puedeMoverse(){
		return self.arrastreUtilTotal() >= self.pesoTotalVagones()
	}
	
	method kilosDeEmpujeFaltantes(){
		var kilosFaltantes 
		if(self.puedeMoverse()){
			kilosFaltantes = 0
		} else {
			kilosFaltantes = self.pesoTotalVagones() - self.arrastreUtilTotal()
		}
		return kilosFaltantes
	}
	
	// agrego este metodo para poder usarlo en el metodo vagonesMasPesados de Deposito	
	method vagonMasPesado(){
		return vagones.max { vagon => vagon.pesoMaximo()}
	}
	
	method esCompleja(){
		var compleja = false
		var unidades = locomotoras.size() + vagones.size()
		var pesoTotal = locomotoras.sum{ locomotora => locomotora.peso() } + vagones.sum {vagon => vagon.pesoMaximo()}
		if( unidades > 20 or pesoTotal >10000) {
			compleja = true
		}
		return compleja
	}
	
	method tieneBaniosSuficiente() {
		var banios =  vagones.sum{vagon => vagon.cantidadDeBanios() }
		var baniosCanti = vagones.sum {vagon => vagon.cantidadDePasajeros() / 50}
	    return banios == baniosCanti
	}
	
	
	method todoslosVagonesLivianos(){
		return vagones.all{vagon=> vagon.esLiviano()}
	}
	
	method estaBienArmada() { return self.puedeMoverse()  }
}

class FormacionDeAltaVelocidad inherits FormacionDeLargaDistancia{
	override method estaBienArmada() {
		return super() and self.todoslosVagonesLivianos() and self.velocidadMaxima() >250
	}
	

}

class FormacionDeCortaDistancia inherits Formacion{
	override method estaBienArmada(){
		return super() and not self.esCompleja()
	}
	
	override method velocidadMaxima() = 60
}

class FormacionDeLargaDistancia inherits Formacion {
	
	override method estaBienArmada(){
		return super() and self.tieneMuchosBanios()
	}
	
	override method velocidadMaxima(){
		var velocidadMaxima
		if(destinoGranciudad){
			velocidadMaxima =200
		} else {
			velocidadMaxima = 150
		}
		return velocidadMaxima
	}
}

class VagonDePasajeros inherits Vagon {
	var largo = 1
	var anchoUtil = 1 
    const cargaMaxima = 0
	
	method largo(){
		return largo 
	}
	
	method largo(metros){
		largo = metros
	}
	
	method anchoUtil(){
		return anchoUtil
	}
	
	method anchoUtil(metros){
		anchoUtil = metros
	}
	
	method cantidadDePasajeros(){
		var cantidad = 0
		if( self.anchoUtil() <= 2.5){
     cantidad  = self.largo()* 8
		} else  {
			 cantidad = self.largo() * 10
		}
		return cantidad
	}
	
	method cargaMaxima(){
		return cargaMaxima
	}
	
	override method pesoMaximo() {
		
return self.cantidadDePasajeros() * 80
	}
	
	method cantidadDeBanios(){
		return self.cantidadDePasajeros() / 50
	}
	
	
	
}

class Vagon {
	method pesoMaximo()
	
	method esLiviano() = self.pesoMaximo() < 2500
}

class VagonDeCarga inherits Vagon {
	var   cargaMaxima = 0
	
	method cargaMaxima(){
		return cargaMaxima
	}
	
	method cargaMaxima(kilos) {
		cargaMaxima = kilos
	}
	
	override method pesoMaximo() {
		return self.cargaMaxima() + 160
	}
	
	//agregado para mantener el polimorfismo
	method cantidadDeBanios(){
		return 0
	}
	
	// agregado para mantener el polimorfismo
	method cantidadDePasajeros() = 0
	
	
}

class Locomotora {
	var peso 
	var pesoMaximo 
	var velocidadMaxima 
	
	method peso(){
		return peso
	}
	
	method peso(kilos) {
		peso = kilos
	}
	
	method pesoMaximo() {
		return pesoMaximo
	}
	
	method pesoMaximo(kilos) {
		pesoMaximo = kilos
	}
	
	method velocidadMaxima()
	{
		return velocidadMaxima
	}
	
	method velocidadMaxima(kmh){
		velocidadMaxima = kmh
	}
	
	method arrastreUtil(){
		return self.pesoMaximo() - self.peso()
	}
}

class Deposito {
	// conjuto de "trenes" ya armados
	var  formaciones = #{}
	var locomotorasSueltas = #{}
	
	method guardarFormacion(formacion){
		formaciones.add(formacion)
	}
	
	method agregarLocomotoraAFormacion(formacion){
		if(not formacion.puedeMoverse() and hayLocomotoraParaMoverse()){
			locomotorasSueltas
		}
	}
	
	method hayLocomotoraParaMoverse(){
		locomotorasSueltas.any{locomotora => locomotora.sirveParaMoverse()}
	}
				
		method vagoneMasPesados(){ 
          var pesados =  formaciones.map { formacion => formacion.vagonMasPesado()}
		  return pesados.asSet()
		}
		
		method necesitaConductorExperimentado(){
			return formaciones.any {formacion => formacion.esCompleja()}
		}
}


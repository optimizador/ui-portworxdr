require 'sinatra'
require 'rest-client'

set(:cookie_options) do
    { :expires => Time.now + 30*60 }
end

get '/menu' do
  redirect "http://169.57.7.203:30543/"
end

get '/' do
  logger = Logger.new(STDOUT)
  logger.info(request)
  @name = "PORTWORX"
  respuesta = []
  response.set_cookie("llave", value: "valor")
  erb :portworx , :locals => {:respuesta => respuesta}
end

get '/portworx-precio' do

  logger = Logger.new(STDOUT)
  logger.info("Parámetros para dimensionamiento portworx:\n")

  #CLUSTER IKS/OCP
  cluster_type_prod="#{params['cluster_type_prod']}"
  wn_prod="#{params['wn_prod']}"
  infra_type_prod="#{params['infra_type_prod']}"
  flavor_prod="#{params['flavor_prod']}"
  region_cluster_prod="#{params['region_cluster_prod']}"

  cluster_type_dr="#{params['cluster_type_dr']}"
  wn_dr="#{params['wn_dr']}"
  infra_type_dr="#{params['infra_type_dr']}"
  flavor_dr="#{params['flavor_dr']}"
  region_cluster_dr="#{params['region_cluster_dr']}"

  logger.info("Clúster prod: tipo de cluster: #{cluster_type_prod}, wn: #{wn_prod}, tipo de infra: #{infra_type_prod}, flavor: #{flavor_prod}, región: #{region_cluster_prod}")
  logger.info("Clúster dr: tipo de cluster: #{cluster_type_dr}, wn: #{wn_dr}, tipo de infra: #{infra_type_dr}, flavor: #{flavor_dr}, región: #{region_cluster_dr}")
  #BLOCK STORAGE
  storage_block="#{params['storage_block']}".to_i
  iops="#{params['iops']}"
  replicas="#{params['replicas']}".to_i
  total_storage = replicas * storage_block

  logger.info("Storage: storage(GB): #{total_storage}, iops: #{iops}, region: #{region_cluster_prod}")
  #DB FOR ETCD
  ram_etcd="#{params['ram_etcd']}"
  storage_etcd="#{params['storage_etcd']}"
  cores="#{params['cores']}"
  region_etcd="#{params['region_etcd']}"

  logger.info("DB ETCD: ram(GB): #{ram_etcd}, storage: #{storage_etcd}, cores: #{cores} region: #{region_etcd}")

  urlapi="http://169.57.7.203:30973"

  request = "#{urlapi}/api/lvl2/portworxsol?tipo_cluster_prod=#{cluster_type_prod}&wn_prod=#{wn_prod}&region_cluster_prod=#{region_cluster_prod}&infra_type_prod=#{infra_type_prod}&flavor_prod=#{flavor_prod}&tipo_cluster_dr=#{cluster_type_dr}&wn_dr=#{wn_dr}&region_cluster_dr=#{region_cluster_dr}&infra_type_dr=#{infra_type_dr}&flavor_dr=#{flavor_dr}&iops=#{iops}&region_storage=#{region_cluster_prod}&storage=#{total_storage}&region_etcd=#{region_etcd}&ram_etcd=#{ram_etcd}&storage_etcd=#{storage_etcd}&cores_etcd=#{cores}"
  logger.info(request)
  respuesta = RestClient.get "#{request}", {:params => {}}
  respuesta = JSON.parse(respuesta.to_s)
  logger.info(respuesta)
  

  erb :portworx , :locals => {:respuesta => respuesta}
end




require 'sinatra'
require 'rest-client'

set(:cookie_options) do
    { :expires => Time.now + 30*60 }
end

get '/menu' do
  redirect "https://ui.9sxuen7c9q9.us-south.codeengine.appdomain.cloud//"
end

get '/' do
  logger = Logger.new(STDOUT)
  logger.info(request)
  @name = "PORTWORX"
  respuesta_1 = []
  respuesta_2 = []
  response.set_cookie("llave", value: "valor")
  erb :portworx , :locals => {:respuesta_1 => respuesta_1,:respuesta_2 => respuesta_2}
end

get '/portworx-precio' do

  logger = Logger.new(STDOUT)
  logger.info("Parámetros para dimensionamiento portworx:\n")

  #CLUSTER IKS/OCP
  cluster_type_1="#{params['cluster_type_1']}"
  wn_1="#{params['wn_1']}"
  infra_type_1="#{params['infra_type_1']}"
  flavor_1="#{params['flavor_1']}"
  region_cluster_1="#{params['region_cluster_1']}"

  cluster_type_2="#{params['cluster_type_2']}"
  wn_2="#{params['wn_2']}"
  infra_type_2="#{params['infra_type_2']}"
  flavor_2="#{params['flavor_2']}"
  region_cluster_2="#{params['region_cluster_2']}"

  logger.info("Clúster 1: tipo de cluster: #{cluster_type_1}, wn: #{wn_1}, tipo de infra: #{infra_type_1}, flavor: #{flavor_1}, región: #{region_cluster_1}")
  logger.info("Clúster 2: tipo de cluster: #{cluster_type_2}, wn: #{wn_2}, tipo de infra: #{infra_type_2}, flavor: #{flavor_2}, región: #{region_cluster_2}")
  #BLOCK STORAGE
  storage_block="#{params['storage_block_1']}"
  iops="#{params['iops_1']}"

  logger.info("Storage 1: storage(GB): #{storage_block}, iops: #{iops}, region: #{region_cluster_1}")
  logger.info("Storage 2: storage(GB): #{storage_block}, iops: #{iops}, region: #{region_cluster_2}")
  #DB FOR ETCD
  ram_etcd="#{params['ram_etcd_1']}"
  storage_etcd="#{params['storage_etcd_1']}"
  cores="#{params['cores_1']}"

  logger.info("DB ETCD 1: ram(GB): #{ram_etcd}, storage: #{storage_etcd}, cores: #{cores} region: #{region_cluster_1}")
  logger.info("DB ETCD 2: ram(GB): #{ram_etcd}, storage: #{storage_etcd}, cores: #{cores} region: #{region_cluster_2}")

  
  respuestasizing=[]
  respuestasizingalt=[]
  respuestaprecio=[]


  urlapi="https://apis-portworx.9sxuen7c9q9.us-south.codeengine.appdomain.cloud"

  request = "#{urlapi}/api/lvl2/portworxsol?tipo_cluster=#{cluster_type_1}&wn=#{wn_1}&region_cluster=#{region_cluster_1}&infra_type=#{infra_type_1}&flavor=#{flavor_1}&iops=#{iops}&region_storage=#{region_cluster_1}&storage=#{storage_block}&region_etcd=#{region_cluster_1}&ram_etcd=#{ram_etcd}&storage_etcd=#{storage_etcd}&cores_etcd=#{cores}&region_portworx=dallas"
  logger.info(request)
  respuesta_1 = RestClient.get "#{request}", {:params => {}}
  respuesta_1 = JSON.parse(respuesta_1.to_s)
  logger.info(respuesta_1)
  jsonobj = respuesta_1.to_json
  logger.info("Valor en JSON")
  logger.info(jsonobj)

  request = "#{urlapi}/api/lvl2/portworxsol?tipo_cluster=#{cluster_type_2}&wn=#{wn_2}&region_cluster=#{region_cluster_2}&infra_type=#{infra_type_2}&flavor=#{flavor_2}&iops=#{iops}&region_storage=#{region_cluster_2}&storage=#{storage_block}&region_etcd=#{region_cluster_2}&ram_etcd=#{ram_etcd}&storage_etcd=#{storage_etcd}&cores_etcd=#{cores}&region_portworx=dallas"
  logger.info(request)
  respuesta_2 = RestClient.get "#{request}", {:params => {}}
  respuesta_2 = JSON.parse(respuesta_2.to_s)
  logger.info(respuesta_2)

  erb :portworx , :locals => {:respuesta_1 => respuesta_1, :respuesta_2 => respuesta_2}
end




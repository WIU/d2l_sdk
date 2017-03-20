require_relative "requests"

# init products to newest versions.
$le_ver = get_latest_product_version('le')
$lp_ver = get_latest_product_version('lp')
$ep_ver = get_latest_product_version('ep')
#lti, rp, LR, ext,
puts "versions set to:"
versions = {
  "le_ver" => $le_ver,
  "lp_ver" => $lp_ver,
  "ep_ver" => $ep_ver
}
ap versions

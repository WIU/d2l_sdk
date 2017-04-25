require_relative "requests"

# init products to newest versions.
$le_ver = get_latest_product_version('le') # learning environment
$lp_ver = get_latest_product_version('lp') # learning platform
$ep_ver = get_latest_product_version('ep') # Eportfolio
$LR_ver = get_latest_product_version('LR') # Learning repository
$bas_ver = get_latest_product_version('bas') # Award service
$lti_ver = get_latest_product_version('lti') # learning tools interoperability
# ext

# lti, rp, LR, ext,
puts "versions set to:"
versions = {
  'Learning Environment' => $le_ver,
  'Learning Platform' => $lp_ver,
  'Eportfolio' => $ep_ver,
  'Learning Object Repository' => $LR_ver,
  'Award Service' => $bas_ver,
  'Learning Tools Interoperability' => $lti_ver
}
ap versions

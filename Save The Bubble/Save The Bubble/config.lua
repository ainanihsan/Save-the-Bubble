--calculate the aspect ratio of the device
local aspectRatio = display.pixelHeight / display.pixelWidth
application = 
{
   	content = 
   {
      width = aspectRatio > 1.5 and 800 or math.floor( 1200 / aspectRatio ),
      height = aspectRatio < 1.5 and 1200 or math.floor( 800 * aspectRatio ),
      scale = "letterBox",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.3,
      },
   },
   	license =
   {
        google =
        {
            -- The "key" value is obtained from Google.
            key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqD8joq4z3U3S4AdqKjOrOyY7EM/FdMeS7h+IwY5zTcutBrDU2o2m6mMoGPL8y0OHfJ1OqXRz6yeMoRqxc4F/+0fyr0zr0Weh3gtjTKAUpLm2q+80lQoAd2wLyfbqZLTv/IVgQUdYUDnLwpGiwC/6oslPfIXBGFNY92AWSGKMjCxJfHJEVUkhqwsIDsXetNNgu/1MbTmDShiC9TnGQnalC8R7+aRICa+7zbVd/7/I1jl4CVMZjmLQ9KasHV0bhhzO5f9fVdbV0c/su69M9PgPRFAfsmRGhkcEBN8zEkFYBSc9MNKaRkkhwGSeWbBr9rpA33ChKEKpP6cDpvAHnlK0hwIDAQAB",
            policy = "serverManaged"
        },
   },
   	notification = 
    {
        iphone = {
            types = {
                "badge", "sound", "alert"
            }
        }
    }
}
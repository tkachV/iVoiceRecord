

iVoiceRecord PROJECT.
=

README description:
-

Implementation of a simple voice recorder with special logic for trimming audio tracks.
=

= The project is built on mixing architectural approaches Viper and MVVM. Architecture at the stage of inventing... :) I call it the architecture of the functional view models. 
-


---- Reasons for Pods usage:
=

- pod 'RxSwift'                                
    -> Suggestion by customer
- pod 'RxCocoa'                               
    -> + Suggestion by customer
- pod 'RxDataSources'                     
    -> Simple library for advanced usage RxSwift framework.
- pod 'PinLayout'                              
    -> Good library for usage with UI elements that need to be quickly render to harmonize delay and scrolling. (use for TableView elements and CollectionView elements)
- pod 'SnapKit'                                  
    -> Good library for the use of layout constraints.

Detailed description will be  soon .... :)
-
- PS. There were some problems with trimming audio files into parts, since the duration is not always a multiple of 3 seconds. An internal limiter was added and the minimum track recording length was 3 seconds. Only yesterday I added this logic, I did not find another quick solution.


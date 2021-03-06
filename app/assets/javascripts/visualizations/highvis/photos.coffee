###
  * Copyright (c) 2011, iSENSE Project. All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  * Redistributions of source code must retain the above copyright notice, this
  * list of conditions and the following disclaimer. Redistributions in binary
  * form must reproduce the above copyright notice, this list of conditions and
  * the following disclaimer in the documentation and/or other materials
  * provided with the distribution. Neither the name of the University of
  * Massachusetts Lowell nor the names of its contributors may be used to
  * endorse or promote products derived from this software without specific
  * prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
  * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  * DAMAGE.
  *
###
$ ->
  if namespace.controller is "visualizations" and namespace.action in ["displayVis", "embedVis", "show"]

    class window.Photos extends BaseVis
      numPhotos = 0
      constructor: (@canvas) ->
      start: ->
        ($ '#' + @canvas).show()

        # Hide the controls
        @hideControls()

        super()

      # Gets called when the controls are clicked and at start
      update: ->
        # Clear the old canvas
        ($ '#' + @canvas).html('')

        ($ '#' + @canvas).append '<div id="polaroid"></div>'

        i = 0
        imgWidth = 200
        defMargins = 20
        excess = 0
        for ds of data.metadata
          numPhotos += data.metadata[ds].photos.length
        divWidth = ($ '#polaroid').width()
        if((imgWidth + defMargins) * numPhotos + defMargins < divWidth )
          defMargins = 20
        else
          imgsPerLine = Math.floor(divWidth / (imgWidth + defMargins))
          if imgsPerLine * (imgWidth + defMargins) + defMargins >= divWidth
            imgsPerLine -= 1
          excess = divWidth - (imgsPerLine * (defMargins + imgWidth) + 20)
        ($ '#polaroid').css( 'margin-left': "#{(defMargins / 2) + (excess / 2)}px",
          'margin-right': "#{(defMargins / 2) + (excess / 2)}px",
          'margin-top': "#{defMargins / 2}px", 'margin-bottom': "#{defMargins / 2}px")
        for ds of data.metadata
          if data.metadata[ds].photos.length > 0
            for pic of data.metadata[ds].photos
              tmp = data.metadata[ds].photos[pic]
              dset = data.metadata[ds]
              do(tmp, dset) ->
                figure = """<div class='p_item'>
                  <img id='pic_#{i}' src="#{tmp.tn_src}" class='caroucell'/> <br>
                  <div class="caption_wrap"><span class="caption">Data Set: #{dset.name}(#{dset.dataset_id})
                  </span></div> <br>
                </div>"""
                ($ "#polaroid").append figure
                ($ '#pic_' + i).css( cursor: "pointer")
                ($ '#pic_' + i).click ->
                  ($ '#polaroid').append("""
                    <div class="modal fade" id="target_img" tabindex='-1'>
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"
                              aria-hidden="true"><i class="fa fa-times"></i> Close</button>
                          </div>
                          <div class="modal-body">
                            <img src='#{tmp.src}' style='width:100%'/>
                          </div>
                        </div>
                      </div>
                    </div>
                    """)

                  ($ '#target_img').modal
                    keyboard: true
                  ($ '#target_img').on "hidden.bs.modal", ->
                    ($ '#target_img').remove()
              i++
              ($ '.p_item').css('margin': "#{defMargins / 2}px")
      end: ->
        @unhideControls()
        super()

      drawControls: ->
        super()
    if "Photos" in data.relVis
      globals.photos = new Photos "photos_canvas"
    else
      globals.photos = new DisabledVis "photos_canvas"

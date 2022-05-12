<template>
    <div id="app">
      <div class="chat-window" :style="this.style" :class="{
          'animated': !showWindow && hideAnimated,
          'hidden': !showWindow
        }">
        <div class="chat-messages" ref="messages">
          <message v-for="msg in filteredMessages"
                   :templates="templates"
                   :multiline="msg.multiline"
                   :args="msg.args"
                   :params="msg.params"
                   :color="msg.color"
                   :template="msg.template"
                   :template-id="msg.templateId"
                   :key="msg.id">
          </message>
        </div>
      </div>
      <div class="chat-input">
        <div v-show="showInput" class="input">
          <span class="prefix" :class="{ any: modes.length > 1 }" :style="{ color: modeColor }">{{modePrefix}}</span>
      
          <textarea style="font-weight: bold;resize : none" 
          v-model="message"
                    ref="input"
                    type="text"
                    autofocus
                    spellcheck="false"
                    
                    rows="1"
                    @keyup.esc="hideInput"
                    @keyup="keyUp"
                    @keydown="keyDown"
                    @keypress.enter.prevent="send">
          </textarea>

            
        </div>
          <textarea class ="chat-hidden" style="font-weight: bold;resize : none;" 
          v-model="message2"
          rows="1"
          
                    ref="input2"
                    type="text"
                     @keyup="keyUp"
                    @keyup.esc="hideInput">
                     </textarea>
        <suggestions :message="message" :suggestions="suggestions">
        </suggestions>
        <div class="chat-hide-state" v-show="showHideState">
          {{hideStateString}}
        </div>
      </div>
    </div>
</template>

<script lang="ts" src="./App.ts"></script>
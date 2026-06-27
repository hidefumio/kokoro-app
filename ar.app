<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
<title>おはなしカメラ</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{background:#FFF0F5;overflow:hidden;font-family:'Hiragino Maru Gothic Pro','Hiragino Sans',sans-serif}

/* ═══════════════════════════════════
   SPLASH
═══════════════════════════════════ */
#splash{
  position:fixed;inset:0;z-index:300;
  background:linear-gradient(160deg,#FFD6E8 0%,#FFF0F5 50%,#FFEEF8 100%);
  display:flex;flex-direction:column;align-items:center;justify-content:center;
  padding:24px;text-align:center;overflow:hidden;
}

/* Rainbow shimmer bg */
#splash::before{
  content:'';position:absolute;inset:0;
  background:repeating-linear-gradient(135deg,
    rgba(255,182,212,.15) 0px,rgba(255,182,212,.15) 2px,
    transparent 2px,transparent 20px);
  animation:bgShift 8s linear infinite;
}
@keyframes bgShift{from{background-position:0 0}to{background-position:40px 40px}}

/* Floating bubbles bg */
.fbubble{
  position:absolute;border-radius:50%;
  animation:rise linear infinite;
  pointer-events:none;
}
@keyframes rise{
  0%{transform:translateY(110vh) scale(0);opacity:0}
  10%{opacity:.6}
  90%{opacity:.4}
  100%{transform:translateY(-20vh) scale(1.2);opacity:0}
}

/* OneHeart logo */
.oh-logo{width:72px;height:72px;margin-bottom:4px;animation:logoBounce 2s ease infinite}
@keyframes logoBounce{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
.oh-brand{font-size:18px;font-weight:900;color:#C9547A;letter-spacing:2px;margin-bottom:20px}

/* Character */
.chara-wrap{position:relative;margin-bottom:16px}
.chara-svg{width:200px;height:200px;animation:charaFloat 3s ease-in-out infinite}
@keyframes charaFloat{0%,100%{transform:translateY(0) rotate(-2deg)}50%{transform:translateY(-12px) rotate(2deg)}}

/* Halo ring around character */
.halo{
  position:absolute;bottom:-8px;left:50%;transform:translateX(-50%);
  width:90px;height:20px;
  background:radial-gradient(ellipse,rgba(201,84,122,.25),transparent 70%);
  animation:haloBreath 3s ease-in-out infinite;
}
@keyframes haloBreath{0%,100%{width:90px;opacity:.6}50%{width:70px;opacity:.3}}

/* Sparkle stars around character */
.cstar{position:absolute;font-size:16px;animation:starSpin 2s ease-in-out infinite}
@keyframes starSpin{0%,100%{transform:scale(1) rotate(0deg);opacity:1}50%{transform:scale(.5) rotate(180deg);opacity:.4}}

/* Title */
.splash-title{
  font-size:30px;font-weight:900;
  background:linear-gradient(135deg,#FF6BAE,#C9547A,#FF6BAE);
  background-size:200% auto;
  -webkit-background-clip:text;-webkit-text-fill-color:transparent;
  animation:titleShine 2.5s linear infinite;
  letter-spacing:2px;margin-bottom:6px;
}
@keyframes titleShine{0%{background-position:0%}100%{background-position:200%}}

.splash-sub{font-size:13px;color:#B07A90;line-height:1.8;margin-bottom:28px}

/* Bouncy dots under sub */
.bounce-dots{display:flex;gap:6px;justify-content:center;margin-bottom:20px}
.bdot{
  width:8px;height:8px;border-radius:50%;background:#FF8FB1;
  animation:dotBounce .8s ease-in-out infinite;
}
.bdot:nth-child(2){animation-delay:.15s}
.bdot:nth-child(3){animation-delay:.3s}
@keyframes dotBounce{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}

/* Start button */
.start-btn{
  position:relative;overflow:hidden;
  padding:16px 44px;border:none;border-radius:50px;
  background:linear-gradient(135deg,#FF8FB1 0%,#FF5C9A 50%,#C9547A 100%);
  background-size:200% auto;
  color:white;font-size:17px;font-weight:900;cursor:pointer;
  letter-spacing:1px;
  box-shadow:0 8px 0 #A03060,0 12px 28px rgba(201,84,122,.4);
  transition:transform .12s,box-shadow .12s;
  animation:btnGlow 2s ease-in-out infinite;
}
@keyframes btnGlow{0%,100%{box-shadow:0 8px 0 #A03060,0 12px 28px rgba(201,84,122,.4)}50%{box-shadow:0 8px 0 #A03060,0 12px 40px rgba(201,84,122,.7)}}
.start-btn::after{
  content:'';position:absolute;top:-50%;left:-60%;width:40%;height:200%;
  background:rgba(255,255,255,.3);transform:skewX(-20deg);
  animation:btnSheen 3s ease infinite;
}
@keyframes btnSheen{0%{left:-60%}40%,100%{left:130%}}
.start-btn:active{transform:translateY(6px);box-shadow:0 2px 0 #A03060}

/* Floating emoji around button */
.femoji{
  position:absolute;font-size:22px;
  animation:emojiFloat 4s ease-in-out infinite;
  pointer-events:none;
}
@keyframes emojiFloat{0%,100%{transform:translateY(0) rotate(-10deg)}50%{transform:translateY(-18px) rotate(10deg)}}

/* ═══════════════════════════════════
   CAMERA
═══════════════════════════════════ */
#camera{position:fixed;inset:0;width:100%;height:100%;object-fit:cover;transform:scaleX(-1)}
#snapCanvas{display:none}

/* ═══════════════════════════════════
   AR OVERLAY
═══════════════════════════════════ */
#overlay{position:fixed;inset:0;pointer-events:none}

/* Scan frame with animated corners */
.scan-frame{
  position:absolute;top:50%;left:50%;
  transform:translate(-50%,-62%);
  width:200px;height:200px;
}
.scan-svg{width:100%;height:100%}

/* Rotating ring */
.scan-ring{
  position:absolute;inset:-12px;border-radius:50%;
  border:3px dashed rgba(255,144,177,.5);
  animation:ringRotate 8s linear infinite;
}
@keyframes ringRotate{to{transform:rotate(360deg)}}

/* Scan shimmer */
.scan-shimmer{
  position:absolute;left:8px;right:8px;height:3px;border-radius:10px;
  background:linear-gradient(90deg,transparent,rgba(255,160,200,.9),transparent);
  animation:shimmerDrop 2s ease-in-out infinite;
}
@keyframes shimmerDrop{0%{top:8px;opacity:0}15%{opacity:1}85%{opacity:1}100%{top:192px;opacity:0}}

/* ═══════════════════════════════════
   MANGA BUBBLE
═══════════════════════════════════ */
.bubble-wrap{
  position:absolute;top:8%;left:50%;
  transform:translateX(-50%);
  animation:bubblePop .5s cubic-bezier(.34,1.8,.64,1) both;
  min-width:220px;max-width:300px;
}
@keyframes bubblePop{
  0%{opacity:0;transform:translateX(-50%) scale(.3) rotate(-8deg)}
  60%{transform:translateX(-50%) scale(1.08) rotate(2deg)}
  100%{opacity:1;transform:translateX(-50%) scale(1) rotate(0deg)}
}

/* Wobble when shown */
.bubble-wrap.shown{animation:bubblePop .5s cubic-bezier(.34,1.8,.64,1) both, bubbleWobble 3s 1s ease-in-out infinite}
@keyframes bubbleWobble{0%,100%{transform:translateX(-50%) rotate(0deg)}25%{transform:translateX(-50%) rotate(-1.5deg)}75%{transform:translateX(-50%) rotate(1.5deg)}}

.bubble{
  position:relative;padding:16px 20px 18px;
  border-radius:28px;border:4px solid;text-align:center;
}
.bubble.girl{
  background:
    radial-gradient(circle,rgba(255,255,255,.65) 3px,transparent 3px),
    linear-gradient(160deg,#FFB6CE,#FF8FB1);
  background-size:20px 20px,100%;
  border-color:#E05585;
  box-shadow:0 8px 0 #C03060,0 14px 30px rgba(224,85,133,.35);
  animation:bubbleBreath 2.5s ease-in-out infinite;
}
.bubble.boy{
  background:
    radial-gradient(circle,rgba(255,255,255,.65) 3px,transparent 3px),
    linear-gradient(160deg,#7ECEF4,#5AB8F0);
  background-size:20px 20px,100%;
  border-color:#2A8FD4;
  box-shadow:0 8px 0 #1A6FAF,0 14px 30px rgba(42,143,212,.35);
  animation:bubbleBreath 2.5s ease-in-out infinite;
}
@keyframes bubbleBreath{0%,100%{transform:scale(1)}50%{transform:scale(1.02)}}

/* Tail */
.bubble-tail{
  position:absolute;bottom:-28px;left:50%;
  transform:translateX(-50%);
  width:32px;height:28px;
}

.bemo{font-size:38px;display:block;margin-bottom:4px;animation:emojiPop .6s .4s cubic-bezier(.34,1.56,.64,1) both}
@keyframes emojiPop{from{transform:scale(0)}to{transform:scale(1)}}

.blabel{
  font-size:11px;font-weight:900;letter-spacing:2px;margin-bottom:6px;
  animation:fadeSlide .4s .5s ease both;
}
@keyframes fadeSlide{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:translateY(0)}}
.bubble.girl .blabel{color:#7A1040}
.bubble.boy  .blabel{color:#0A3A6A}

.btext{
  font-size:15px;font-weight:700;line-height:1.7;
  animation:fadeSlide .4s .65s ease both;
}
.bubble.girl .btext{color:#5A0030}
.bubble.boy  .btext{color:#082A50}

/* Sparkles burst */
.spark{
  position:absolute;font-size:22px;
  animation:sparkBurst 1.8s ease-out forwards;
}
@keyframes sparkBurst{
  0%{opacity:1;transform:translate(0,0) scale(1)}
  100%{opacity:0;transform:translate(var(--tx),var(--ty)) scale(.2)}
}

/* ═══════════════════════════════════
   BOTTOM UI
═══════════════════════════════════ */
#ui{
  position:fixed;bottom:0;left:0;right:0;
  padding:10px 20px 44px;
  background:linear-gradient(transparent,rgba(0,0,0,.6));
  display:none;flex-direction:column;align-items:center;gap:10px;
}

.name-tag{
  background:rgba(255,255,255,.92);border:3px solid #FF8FB1;
  border-radius:50px;padding:7px 22px;
  font-size:14px;font-weight:900;color:#C9547A;cursor:pointer;
  display:flex;align-items:center;gap:6px;
  box-shadow:0 4px 12px rgba(255,144,177,.3);
  animation:tagPulse 3s ease-in-out infinite;
}
@keyframes tagPulse{0%,100%{box-shadow:0 4px 12px rgba(255,144,177,.3)}50%{box-shadow:0 4px 20px rgba(255,144,177,.6)}}

.gender-row{display:flex;gap:8px}
.gpill{
  padding:10px 22px;border:3px solid;border-radius:50px;
  font-size:13px;font-weight:900;cursor:pointer;transition:all .2s;
}
.gpill.girl{background:#FFB6CE;border-color:#E05585;color:#5A0030}
.gpill.boy {background:#7ECEF4;border-color:#2A8FD4;color:#082A50}
.gpill.dim {opacity:.38;transform:scale(.94)}

/* Shutter button */
#shutter{
  position:relative;
  width:80px;height:80px;border-radius:50%;
  border:5px solid white;
  background:rgba(255,255,255,.2);
  backdrop-filter:blur(8px);
  display:flex;align-items:center;justify-content:center;
  font-size:32px;cursor:pointer;
  box-shadow:0 0 0 8px rgba(255,255,255,.2);
  transition:transform .12s;
  overflow:hidden;
}
#shutter::before{
  content:'';position:absolute;inset:0;border-radius:50%;
  background:conic-gradient(rgba(255,144,177,.4),transparent,rgba(255,144,177,.4));
  animation:shutterSpin 4s linear infinite;
}
@keyframes shutterSpin{to{transform:rotate(360deg)}}
#shutter:active{transform:scale(.86)}
#shutter.loading::after{
  content:'';position:absolute;inset:4px;border-radius:50%;
  border:4px solid transparent;border-top-color:white;
  animation:spin .7s linear infinite;
}
@keyframes spin{to{transform:rotate(360deg)}}

/* Status */
#status{
  position:fixed;top:54px;left:50%;transform:translateX(-50%);
  background:rgba(255,255,255,.88);border:2.5px solid #FFB6CE;
  color:#C9547A;font-size:13px;font-weight:700;
  padding:7px 20px;border-radius:50px;white-space:nowrap;
  backdrop-filter:blur(4px);transition:opacity .3s;
  animation:statusFloat 3s ease-in-out infinite;
}
@keyframes statusFloat{0%,100%{transform:translateX(-50%) translateY(0)}50%{transform:translateX(-50%) translateY(-3px)}}

/* ═══════════════════════════════════
   NAME MODAL
═══════════════════════════════════ */
#nameModal{
  position:fixed;inset:0;background:rgba(0,0,0,.55);
  display:none;align-items:center;justify-content:center;padding:24px;z-index:200;
}
.mcard{
  background:linear-gradient(160deg,#FFF0F5,#FFE4F0);
  border:3px solid #FF8FB1;border-radius:28px;
  padding:28px 24px;width:100%;max-width:300px;text-align:center;
  animation:modalPop .4s cubic-bezier(.34,1.56,.64,1);
}
@keyframes modalPop{from{transform:scale(.5);opacity:0}to{transform:scale(1);opacity:1}}
.mcard h2{font-size:18px;font-weight:900;color:#C9547A;margin-bottom:16px}
.mcard input{
  width:100%;padding:12px;border:2.5px solid #FFB6CE;
  border-radius:14px;font-size:16px;text-align:center;
  outline:none;background:white;margin-bottom:14px;font-family:inherit;
}
.msave{
  width:100%;padding:13px;border:none;border-radius:50px;
  font-size:15px;font-weight:900;cursor:pointer;color:white;
  background:linear-gradient(135deg,#FF8FB1,#C9547A);
  box-shadow:0 5px 0 #A03060;transition:transform .1s,box-shadow .1s;
}
.msave:active{transform:translateY(3px);box-shadow:0 2px 0 #A03060}
</style>
</head>
<body>

<!-- ══════════ SPLASH ══════════ -->
<div id="splash">

  <!-- Floating bubbles -->
  <script>
  (function(){
    const colors=['#FFD6E8','#FFB6CE','#FFC8E0','#FFE4F0','#B3E5FC','#E1BEE7'];
    for(let i=0;i<14;i++){
      const d=document.createElement('div');
      const sz=20+Math.random()*50;
      d.className='fbubble';
      d.style.cssText=`width:${sz}px;height:${sz}px;left:${Math.random()*100}%;background:${colors[Math.floor(Math.random()*colors.length)]};opacity:.5;animation-duration:${6+Math.random()*8}s;animation-delay:${Math.random()*6}s`;
      document.getElementById('splash')?.appendChild(d)||document.body.appendChild(d);
    }
  })();
  </script>

  <!-- Floating emoji -->
  <span class="femoji" style="top:8%;left:6%;animation-delay:0s">💗</span>
  <span class="femoji" style="top:12%;right:8%;animation-delay:.7s">✨</span>
  <span class="femoji" style="top:72%;left:4%;animation-delay:1.2s">🌸</span>
  <span class="femoji" style="top:68%;right:6%;animation-delay:.4s">💕</span>
  <span class="femoji" style="top:40%;left:2%;animation-delay:1.8s">⭐</span>
  <span class="femoji" style="top:45%;right:3%;animation-delay:1s">🌟</span>

  <!-- OneHeart Logo -->
  <svg class="oh-logo" viewBox="0 0 100 100" fill="none">
    <path d="M50 78C50 78 18 60 18 38 C18 26 27 18 38 18 C43 18 48 21 50 25 C52 21 57 18 62 18 C73 18 82 26 82 38 C82 60 50 78 50 78Z" fill="#F9A8C9" stroke="#C9547A" stroke-width="4"/>
    <path d="M56 64C56 64 36 52 36 40 C36 34 40 30 45 30 C48 30 50 32 51 34 C52 32 54 30 57 30 C62 30 66 34 66 40 C66 52 56 64 56 64Z" fill="#F472A0" stroke="#C9547A" stroke-width="3"/>
  </svg>


  <!-- Character -->
  <div class="chara-wrap">
    <div class="halo"></div>
    <span class="cstar" style="top:-8px;left:8px;animation-delay:0s">⭐</span>
    <span class="cstar" style="top:-4px;right:10px;animation-delay:.5s">✨</span>
    <span class="cstar" style="bottom:10px;left:2px;animation-delay:1s">💫</span>

    <!-- Boy rabbit (blue) hidden by default -->
    <svg id="charaBoy" class="chara-svg" viewBox="0 0 130 150" fill="none" style="display:none;position:absolute;top:0;left:0">
      <ellipse cx="44" cy="28" rx="11" ry="24" fill="white" stroke="#B0D8F0" stroke-width="2.5"/>
      <ellipse cx="86" cy="28" rx="11" ry="24" fill="white" stroke="#B0D8F0" stroke-width="2.5"/>
      <ellipse cx="44" cy="28" rx="6" ry="15" fill="#C8E8F8"/>
      <ellipse cx="86" cy="28" rx="6" ry="15" fill="#C8E8F8"/>
      <ellipse cx="65" cy="68" rx="36" ry="34" fill="white" stroke="#B0D8F0" stroke-width="2.5"/>
      <ellipse cx="46" cy="78" rx="9" ry="6" fill="#7ECEF4" opacity=".5"/>
      <ellipse cx="84" cy="78" rx="9" ry="6" fill="#7ECEF4" opacity=".5"/>
      <circle cx="54" cy="62" r="4.5" fill="#2C3E50"/>
      <circle cx="76" cy="62" r="4.5" fill="#2C3E50"/>
      <circle cx="55.5" cy="60" r="1.8" fill="white"/>
      <circle cx="77.5" cy="60" r="1.8" fill="white"/>
      <line x1="60" y1="74" x2="65" y2="80" stroke="#2A8FD4" stroke-width="2.5" stroke-linecap="round"/>
      <line x1="70" y1="74" x2="65" y2="80" stroke="#2A8FD4" stroke-width="2.5" stroke-linecap="round"/>
      <rect x="42" y="98" width="46" height="40" rx="16" fill="#7ECEF4" stroke="#2A8FD4" stroke-width="2.5"/>
      <polygon points="65,90 67,96 73,96 68,100 70,106 65,102 60,106 62,100 57,96 63,96" fill="#FFD700" stroke="#F0A000" stroke-width="1"/>
      <ellipse cx="30" cy="112" rx="11" ry="7" fill="white" stroke="#B0D8F0" stroke-width="2" transform="rotate(-25 30 112)"/>
      <ellipse cx="100" cy="112" rx="11" ry="7" fill="white" stroke="#B0D8F0" stroke-width="2" transform="rotate(25 100 112)"/>
      <polygon points="18,128 20,134 26,134 21,138 23,144 18,140 13,144 15,138 10,134 16,134" fill="#FFD700"/>
      <polygon points="112,128 114,134 120,134 115,138 117,144 112,140 107,144 109,138 104,134 110,134" fill="#FFD700"/>
      <path d="M65 112 C65 112 58 107 58 102 C58 99 61 97 63 97 C64 97 65 98 65 99 C65 98 66 97 67 97 C69 97 72 99 72 102 C72 107 65 112 65 112Z" fill="#2A8FD4"/>
    </svg>

    <!-- Girl rabbit (pink) -->
    <svg id="charaGirl" class="chara-svg" viewBox="0 0 130 150" fill="none">
      <!-- Ears -->
      <ellipse cx="44" cy="30" rx="11" ry="22" fill="white" stroke="#F0C0D0" stroke-width="2.5"/>
      <ellipse cx="86" cy="30" rx="11" ry="22" fill="white" stroke="#F0C0D0" stroke-width="2.5"/>
      <!-- Ear inner pink -->
      <ellipse cx="44" cy="30" rx="6" ry="14" fill="#FFD6E8"/>
      <ellipse cx="86" cy="30" rx="6" ry="14" fill="#FFD6E8"/>
      <!-- Head -->
      <ellipse cx="65" cy="68" rx="36" ry="34" fill="white" stroke="#F0C0D0" stroke-width="2.5"/>
      <!-- Cheeks -->
      <ellipse cx="46" cy="78" rx="9" ry="6" fill="#FFB6CE" opacity=".6"/>
      <ellipse cx="84" cy="78" rx="9" ry="6" fill="#FFB6CE" opacity=".6"/>
      <!-- Eyes -->
      <circle cx="54" cy="62" r="4" fill="#3D2B1F"/>
      <circle cx="76" cy="62" r="4" fill="#3D2B1F"/>
      <circle cx="55.5" cy="60.5" r="1.5" fill="white"/>
      <circle cx="77.5" cy="60.5" r="1.5" fill="white"/>
      <!-- X mouth Miffy -->
      <line x1="60" y1="74" x2="65" y2="80" stroke="#C9547A" stroke-width="2.5" stroke-linecap="round"/>
      <line x1="70" y1="74" x2="65" y2="80" stroke="#C9547A" stroke-width="2.5" stroke-linecap="round"/>
      <!-- Body -->
      <rect x="42" y="98" width="46" height="40" rx="16" fill="#FFB6CE" stroke="#E05585" stroke-width="2.5"/>
      <!-- Collar bow -->
      <path d="M55 98 Q65 92 75 98 Q65 104 55 98Z" fill="#FF8FB1" stroke="#E05585" stroke-width="1.5"/>
      <circle cx="65" cy="98" r="4" fill="#FF5C9A"/>
      <!-- Arms -->
      <ellipse cx="30" cy="112" rx="11" ry="7" fill="white" stroke="#F0C0D0" stroke-width="2" transform="rotate(-25 30 112)"/>
      <ellipse cx="100" cy="112" rx="11" ry="7" fill="white" stroke="#F0C0D0" stroke-width="2" transform="rotate(25 100 112)"/>
      <!-- Flowers -->
      <circle cx="18" cy="138" r="8" fill="#FF8FB1"/>
      <circle cx="18" cy="138" r="4" fill="white"/>
      <circle cx="112" cy="138" r="8" fill="#FF8FB1"/>
      <circle cx="112" cy="138" r="4" fill="white"/>
      <!-- Flower stems -->
      <line x1="18" y1="130" x2="18" y2="146" stroke="#88CC88" stroke-width="2"/>
      <line x1="112" y1="130" x2="112" y2="146" stroke="#88CC88" stroke-width="2"/>
      <!-- Heart on chest -->
      <path d="M65 110 C65 110 58 105 58 100 C58 97 61 95 63 95 C64 95 65 96 65 97 C65 96 66 95 67 95 C69 95 72 97 72 100 C72 105 65 110 65 110Z" fill="#FF5C9A"/>
    </svg>
  </div>

  <div class="splash-title">おはなしカメラ</div>
  <div class="splash-sub">カメラをむけるだけで<br>きもちが伝わるよ 💕</div>

  <div class="bounce-dots">
    <div class="bdot"></div>
    <div class="bdot"></div>
    <div class="bdot"></div>
  </div>

  <button class="start-btn" onclick="startCamera()">
    📷 はじめる
  </button>
</div>

<!-- ══════════ CAMERA ══════════ -->
<video id="camera" autoplay playsinline muted></video>
<canvas id="snapCanvas"></canvas>

<!-- ══════════ AR OVERLAY ══════════ -->
<div id="overlay">
  <div class="scan-frame">
    <div class="scan-ring"></div>
    <svg class="scan-svg" viewBox="0 0 200 200" fill="none">
      <!-- Rounded corner brackets -->
      <path d="M28 8 Q8 8 8 28" stroke="white" stroke-width="4" stroke-linecap="round" fill="none"/>
      <path d="M172 8 Q192 8 192 28" stroke="white" stroke-width="4" stroke-linecap="round" fill="none"/>
      <path d="M8 172 Q8 192 28 192" stroke="white" stroke-width="4" stroke-linecap="round" fill="none"/>
      <path d="M192 172 Q192 192 172 192" stroke="white" stroke-width="4" stroke-linecap="round" fill="none"/>
      <line x1="28" y1="8" x2="62" y2="8" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <line x1="138" y1="8" x2="172" y2="8" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <line x1="8" y1="28" x2="8" y2="62" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <line x1="192" y1="28" x2="192" y2="62" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <line x1="8" y1="138" x2="8" y2="172" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <line x1="192" y1="138" x2="192" y2="172" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <line x1="28" y1="192" x2="62" y2="192" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <line x1="138" y1="192" x2="172" y2="192" stroke="white" stroke-width="4" stroke-linecap="round"/>
      <!-- Center heart -->
      <path d="M100 106C100 106 84 97 84 87C84 81 88 77 93 77C96 77 99 79 100 81C101 79 104 77 107 77C112 77 116 81 116 87C116 97 100 106 100 106Z" fill="rgba(255,144,177,.55)" stroke="rgba(255,255,255,.6)" stroke-width="1.5"/>
    </svg>
    <div class="scan-shimmer"></div>
  </div>
</div>

<div id="status">かおを まるに あわせてね 💕</div>

<!-- ══════════ BOTTOM UI ══════════ -->
<div id="ui">
  <div class="name-tag" onclick="openModal()">
    🌸 <span id="nameDisp">みおたん</span> ✏️
  </div>
  <div class="gender-row">
    <button class="gpill girl" id="gGirl" onclick="setGender('girl')">👧 女の子</button>
    <button class="gpill boy dim" id="gBoy" onclick="setGender('boy')">👦 男の子</button>
  </div>
  <div id="shutter" onclick="doScan()"><span id="shutterIcon">🌸</span></div>
</div>

<!-- ══════════ NAME MODAL ══════════ -->
<div id="nameModal" onclick="if(event.target===this)this.style.display='none'">
  <div class="mcard">
    <h2>🌸 なまえを おしえてね</h2>
    <input id="nameInput" type="text" placeholder="例：みおたん" maxlength="10"/>
    <button class="msave" onclick="saveName()">決定！ ✨</button>
  </div>
</div>

<script>
const API_KEY="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";
let gender='girl', childName='みおたん', scanning=false;

async function startCamera(){
  try{
    const s=await navigator.mediaDevices.getUserMedia({video:{facingMode:'environment'},audio:false});
    document.getElementById('camera').srcObject=s;
  }catch(e){
    try{
      const s=await navigator.mediaDevices.getUserMedia({video:true,audio:false});
      document.getElementById('camera').srcObject=s;
    }catch(e2){alert('カメラを許可してください');return;}
  }
  document.getElementById('splash').style.display='none';
  document.getElementById('ui').style.display='flex';
  setStatus('かおを まるに あわせてね 💕');
}

function captureFrame(){
  const v=document.getElementById('camera');
  const c=document.getElementById('snapCanvas');
  c.width=v.videoWidth||640;c.height=v.videoHeight||480;
  const ctx=c.getContext('2d');
  ctx.save();ctx.scale(-1,1);ctx.drawImage(v,-c.width,0,c.width,c.height);ctx.restore();
  return c.toDataURL('image/jpeg',.7).split(',')[1];
}

async function doScan(){
  if(scanning)return;
  scanning=true;
  const btn=document.getElementById('shutter');
  btn.classList.add('loading');
  document.getElementById('shutterIcon').textContent='⏳';
  setStatus('よんでいます… 💕');
  removeBubble();
  try{
    const b64=captureFrame();
    const r=await analyzeEmotion(b64);
    showBubble(r);
    setStatus('');
  }catch(e){
    setStatus('もう いちど ためしてね 💕');
    setTimeout(()=>setStatus('かおを まるに あわせてね 💕'),2500);
  }
  btn.classList.remove('loading');
  document.getElementById('shutterIcon').textContent='🌸';
  scanning=false;
}

async function analyzeEmotion(b64){
  const system=`重症心身障害児の表情AIです。子どもの一人称で短くやさしく。
JSONのみ:{"emotion":"comfort|joy|pain|fatigue|distress|seeking|neutral","emoji":"絵文字1つ","message":"ひらがな多め2文以内","emotionLabel":"日本語ラベル"}`;
  const res=await fetch('https://api.anthropic.com/v1/messages',{
    method:'POST',
    headers:{'Content-Type':'application/json','x-api-key':API_KEY,'anthropic-version':'2023-06-01'},
    body:JSON.stringify({
      model:'claude-sonnet-4-6',max_tokens:200,system,
      messages:[{role:'user',content:[
        {type:'image',source:{type:'base64',media_type:'image/jpeg',data:b64}},
        {type:'text',text:`${childName}の表情を読んで${childName}の言葉で。`}
      ]}]
    })
  });
  const data=await res.json();
  return JSON.parse(data.content.map(c=>c.text||'').join('').replace(/```json|```/g,'').trim());
}

function showBubble(r){
  removeBubble();
  const ov=document.getElementById('overlay');
  const wrap=document.createElement('div');
  wrap.id='bWrap';wrap.className='bubble-wrap shown';

  const tc=gender==='girl'?'#E05585':'#2A8FD4';
  const fc=gender==='girl'?'#FFB6CE':'#7ECEF4';

  const bub=document.createElement('div');
  bub.className=`bubble ${gender}`;
  bub.innerHTML=`
    <span class="bemo">${r.emoji||'🌸'}</span>
    <div class="blabel">${r.emotionLabel||''}</div>
    <div class="btext">${r.message||''}</div>
    <svg class="bubble-tail" viewBox="0 0 32 28" fill="none">
      <polygon points="0,0 32,0 16,26" fill="${tc}"/>
      <polygon points="4,0 28,0 16,20" fill="${fc}"/>
    </svg>
  `;
  wrap.appendChild(bub);
  ov.appendChild(wrap);

  // Burst sparkles in all directions
  const sparks=gender==='girl'?['💗','🌸','✨','💕','🎀','⭐']:['💙','⭐','✨','🌟','💫','🎵'];
  for(let i=0;i<8;i++){
    setTimeout(()=>{
      const s=document.createElement('div');s.className='spark';
      const angle=Math.random()*360;
      const dist=60+Math.random()*60;
      const tx=Math.cos(angle*Math.PI/180)*dist+'px';
      const ty=Math.sin(angle*Math.PI/180)*dist+'px';
      s.style.cssText=`--tx:${tx};--ty:${ty};left:${20+Math.random()*60}%;top:${15+Math.random()*30}%;animation-delay:${Math.random()*.3}s`;
      s.textContent=sparks[Math.floor(Math.random()*sparks.length)];
      ov.appendChild(s);
      setTimeout(()=>s.remove(),2000);
    },i*80);
  }
  setTimeout(removeBubble,9000);
}

function removeBubble(){const w=document.getElementById('bWrap');if(w)w.remove();}

function setGender(g){
  gender=g;
  document.getElementById('gGirl').className='gpill girl'+(g==='girl'?'':' dim');
  document.getElementById('gBoy').className='gpill boy'+(g==='boy'?'':' dim');
  const girl=document.getElementById('charaGirl');
  const boy=document.getElementById('charaBoy');
  if(girl&&boy){
    girl.style.display=g==='girl'?'block':'none';
    boy.style.display=g==='boy'?'block':'none';
  }
  const splash=document.getElementById('splash');
  if(splash){
    splash.style.background=g==='girl'
      ?'linear-gradient(160deg,#FFD6E8 0%,#FFF0F5 50%,#FFEEF8 100%)'
      :'linear-gradient(160deg,#D6EEFF 0%,#F0F8FF 50%,#E8F4FF 100%)';
  }
}

function openModal(){
  document.getElementById('nameInput').value=childName;
  document.getElementById('nameModal').style.display='flex';
}
function saveName(){
  const v=document.getElementById('nameInput').value.trim();
  if(v){childName=v;document.getElementById('nameDisp').textContent=v;}
  document.getElementById('nameModal').style.display='none';
}
function setStatus(m){
  const el=document.getElementById('status');
  el.textContent=m;el.style.opacity=m?'1':'0';
}
</script>
</body>
</html>

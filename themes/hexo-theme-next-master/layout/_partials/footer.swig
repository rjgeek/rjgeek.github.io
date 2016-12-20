<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-heart"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>

<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="http://hexo.io" rel="external nofollow">Hexo</a>') }}
</div>

<div class="theme-info">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next" rel="external nofollow">
    NexT.{{ theme.scheme }}
  </a>
  <span id="busuanzi_container_site_pv">
    Total visited 本站总访问量<span id="busuanzi_value_site_pv"></span>次
  </span>
  
  <span id="busuanzi_container_site_uv">
  Total visitors 本站访客数<span id="busuanzi_value_site_uv"></span>人次
  </span>

</div>


<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js">
</script>
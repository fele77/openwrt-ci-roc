# 修改默认IP
sed -i 's/192.168.1.1/10.10.77.253/g' package/base-files/files/bin/config_generate

# 修改亚瑟LED为绿色
# sed -i 's/&status_blue/\&status_green/g' target/linux/qualcommax/files/arch/arm64/boot/dts/qcom/ipq6000-re-ss-01.dts

# 移除要替换的包
rm -rf feeds/packages/net/alist
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/packages/net/ariang

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Alist & AdGuardHome & 集客无线AC控制器 & Lucky & AriaNg
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
#git_sparse_clone main https://github.com/kenzok8/small-package adguardhome luci-app-adguardhome
#git_sparse_clone master https://github.com/immortalwrt/packages net/ariang 
#git clone --depth=1 https://github.com/lwb1978/openwrt-gecoosac package/openwrt-gecoosac
git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/lucky

./scripts/feeds update -a
./scripts/feeds install -a
